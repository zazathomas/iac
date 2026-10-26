#!/usr/bin/env python3
"""Discover application-owned Keycloak resources and generate Terraform adoption files."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
import time
from pathlib import Path
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import quote, urlencode
from urllib.request import Request, urlopen


INTERNAL_CLIENT_IDS = {
    "account",
    "account-console",
    "admin-cli",
    "broker",
    "realm-management",
    "security-admin-console",
}

INTERNAL_SCOPE_NAMES = {
    "acr",
    "address",
    "basic",
    "email",
    "microprofile-jwt",
    "offline_access",
    "phone",
    "profile",
    "roles",
    "web-origins",
}

INTERNAL_REALM_ROLE_NAMES = {
    "offline_access",
    "uma_authorization",
}

SECRET_KEY_PARTS = ("secret", "password", "privatekey", "private_key", "token")


class KeycloakApi:
    def __init__(self) -> None:
        self.url = os.environ.get("KEYCLOAK_URL", "").rstrip("/")
        self.base_path = os.environ.get("KEYCLOAK_BASE_PATH", "").strip("/")
        self.auth_realm = os.environ.get("KEYCLOAK_REALM", "master")
        self.client_id = os.environ.get("KEYCLOAK_CLIENT_ID", "")
        self.client_secret = os.environ.get("KEYCLOAK_CLIENT_SECRET", "")
        self.access_token = os.environ.get("KEYCLOAK_ACCESS_TOKEN", "")
        # Cloudflare Browser Integrity Check can reject urllib's default Python user agent.
        self.user_agent = os.environ.get("KEYCLOAK_USER_AGENT", "curl/8.7.1")
        self.timeout = float(os.environ.get("KEYCLOAK_HTTP_TIMEOUT", "30"))
        self.retries = max(0, int(os.environ.get("KEYCLOAK_HTTP_RETRIES", "3")))
        if not self.url:
            raise RuntimeError("KEYCLOAK_URL is required")
        if not self.access_token and not (self.client_id and self.client_secret):
            raise RuntimeError(
                "Set KEYCLOAK_ACCESS_TOKEN or KEYCLOAK_CLIENT_ID and KEYCLOAK_CLIENT_SECRET"
            )
        self._token: str | None = self.access_token or None

    @property
    def prefix(self) -> str:
        return f"{self.url}/{self.base_path}" if self.base_path else self.url

    def authenticate(self) -> None:
        if self._token:
            return
        path = f"/realms/{quote(self.auth_realm, safe='')}/protocol/openid-connect/token"
        body = urlencode(
            {
                "grant_type": "client_credentials",
                "client_id": self.client_id,
                "client_secret": self.client_secret,
            }
        ).encode()
        request = Request(
            self.prefix + path,
            data=body,
            headers={
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "User-Agent": self.user_agent,
            },
            method="POST",
        )
        for attempt in range(self.retries + 1):
            try:
                with urlopen(request, timeout=self.timeout) as response:
                    payload = json.load(response)
                self._token = payload["access_token"]
                return
            except HTTPError as error:
                if error.code in {408, 429, 500, 502, 503, 504} and attempt < self.retries:
                    time.sleep(2**attempt)
                    continue
                raise RuntimeError(
                    f"Keycloak token request failed ({error.code}) at {self.prefix + path}"
                ) from error
            except URLError as error:
                if attempt < self.retries:
                    time.sleep(2**attempt)
                    continue
                raise RuntimeError(
                    f"Could not reach Keycloak token endpoint at {self.prefix + path}: {error.reason}"
                ) from error

    def request(self, method: str, path: str, query: dict[str, Any] | None = None) -> Any:
        self.authenticate()
        url = self.prefix + path
        if query:
            url += "?" + urlencode(query)
        request = Request(
            url,
            headers={
                "Accept": "application/json",
                "Authorization": f"Bearer {self._token}",
                "User-Agent": self.user_agent,
            },
            method=method,
        )
        for attempt in range(self.retries + 1):
            try:
                with urlopen(request, timeout=self.timeout) as response:
                    if response.status == 204:
                        return None
                    return json.load(response)
            except HTTPError as error:
                if error.code in {408, 429, 500, 502, 503, 504} and attempt < self.retries:
                    time.sleep(2**attempt)
                    continue
                raise RuntimeError(
                    f"Keycloak API {method} {path} failed ({error.code})"
                ) from error
            except URLError as error:
                if attempt < self.retries:
                    time.sleep(2**attempt)
                    continue
                raise RuntimeError(f"Could not reach Keycloak at {url}: {error.reason}") from error

    def admin(self, realm: str, path: str = "", query: dict[str, Any] | None = None) -> Any:
        realm_path = quote(realm, safe="")
        return self.request("GET", f"/admin/realms/{realm_path}{path}", query)

    def list_all(self, realm: str, path: str) -> list[dict[str, Any]]:
        items: list[dict[str, Any]] = []
        first = 0
        page_size = 1000
        while True:
            page = self.admin(realm, path, {"first": first, "max": page_size})
            if not page:
                break
            items.extend(page)
            if len(page) < page_size:
                break
            first += page_size
        return items


def is_secret_key(key: str) -> bool:
    normalized = key.lower().replace("-", "_")
    return any(part in normalized for part in SECRET_KEY_PARTS)


def redact(value: Any) -> Any:
    if isinstance(value, dict):
        return {
            key: redact(item)
            for key, item in value.items()
            if not is_secret_key(key)
        }
    if isinstance(value, list):
        return [redact(item) for item in value]
    return value


def normalize_attributes(value: Any) -> dict[str, str]:
    if not isinstance(value, dict):
        return {}
    result: dict[str, str] = {}
    for key, item in value.items():
        if is_secret_key(key):
            continue
        if isinstance(item, list):
            result[str(key)] = "##".join(str(part) for part in item)
        elif item is not None:
            result[str(key)] = str(item)
    return result


def hcl(value: Any) -> str:
    # Escape literal Terraform interpolation markers returned by Keycloak.
    return json.dumps(value, ensure_ascii=False, indent=2).replace("${", "$${")


def tf_name(prefix: str, identifier: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9_]", "_", identifier).strip("_").lower() or "item"
    digest = hashlib.sha1(identifier.encode("utf-8")).hexdigest()[:8]
    return f"{prefix}_{slug[: forty]}_{digest}".replace("__", "_")


# Kept as a named constant so generated names stay deterministic and readable.
forty = 40


def resource_address(resource_type: str, name: str) -> str:
    return f"{resource_type}.{name}"


def add_arg(lines: list[str], name: str, value: Any, indent: str = "  ") -> None:
    if value is not None:
        lines.append(f"{indent}{name} = {hcl(value)}")


def add_reference(lines: list[str], name: str, expression: str, indent: str = "  ") -> None:
    lines.append(f"{indent}{name} = {expression}")


def resource_block(resource_type: str, name: str, body: list[str]) -> str:
    return "\n".join([f'resource "{resource_type}" "{name}" {{', *body, "}", ""])


def import_block(address: str, identifier: str) -> str:
    return "\n".join(["import {", f"  to = {address}", f"  id = {hcl(identifier)}", "}", ""])


def load_plan_state(path: Path | None) -> dict[str, dict[str, Any]]:
    if path is None:
        return {}
    plan = json.loads(path.read_text(encoding="utf-8"))
    return {
        item["address"]: item.get("change", {}).get("before") or {}
        for item in plan.get("resource_changes", [])
        if item.get("address")
    }


def flatten_groups(groups: list[dict[str, Any]], parent_id: str | None = None) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for group in groups:
        item = dict(group)
        item["parent_id"] = parent_id
        result.append(item)
        result.extend(flatten_groups(group.get("subGroups") or [], group.get("id")))
    return result


def collect_inventory(api: KeycloakApi, realm: str) -> dict[str, Any]:
    clients = api.list_all(realm, "/clients")
    managed_clients = [
        client
        for client in clients
        if client.get("clientId") not in INTERNAL_CLIENT_IDS
        and not client.get("clientId", "").startswith("account-")
    ]
    client_ids = {client["id"] for client in managed_clients if client.get("id")}

    scopes = api.list_all(realm, "/client-scopes")
    managed_scopes = [scope for scope in scopes if scope.get("name") not in INTERNAL_SCOPE_NAMES]
    scope_ids = {scope["id"] for scope in managed_scopes if scope.get("id")}

    realm_roles = api.list_all(realm, "/roles")
    managed_roles = [
        role
        for role in realm_roles
        if role.get("name") not in INTERNAL_REALM_ROLE_NAMES
        and role.get("name") != f"default-roles-{realm}"
    ]
    for client in managed_clients:
        client_roles = api.list_all(realm, f"/clients/{quote(client['id'], safe='')}/roles")
        managed_roles.extend(client_roles)

    groups = flatten_groups(api.list_all(realm, "/groups"))

    group_mappings: dict[str, Any] = {}
    for group in groups:
        group_id = group.get("id")
        if not group_id:
            continue
        try:
            group_mappings[group_id] = api.admin(realm, f"/groups/{quote(group_id, safe='')}/role-mappings")
        except RuntimeError as error:
            group_mappings[group_id] = {"error": str(error)}

    client_mappers: dict[str, list[dict[str, Any]]] = {}
    for client_id in client_ids:
        client_mappers[client_id] = api.admin(
            realm, f"/clients/{quote(client_id, safe='')}/protocol-mappers/models"
        )

    scope_mappers: dict[str, list[dict[str, Any]]] = {}
    for scope_id in scope_ids:
        scope_mappers[scope_id] = api.admin(
            realm, f"/client-scopes/{quote(scope_id, safe='')}/protocol-mappers/models"
        )

    inventory = {
        "realm": redact(api.admin(realm)),
        "clients": redact(managed_clients),
        "skipped_clients": redact(
            [client for client in clients if client not in managed_clients]
        ),
        "client_scopes": redact(managed_scopes),
        "skipped_client_scopes": redact(
            [scope for scope in scopes if scope not in managed_scopes]
        ),
        "realm_roles": redact(managed_roles),
        "groups": redact(groups),
        "group_role_mappings": redact(group_mappings),
        "client_protocol_mappers": redact(client_mappers),
        "scope_protocol_mappers": redact(scope_mappers),
    }
    return inventory


def generate_terraform(
    inventory: dict[str, Any],
    realm: str,
    plan_state: dict[str, dict[str, Any]] | None = None,
) -> tuple[str, str, list[str]]:
    plan_state = plan_state or {}
    clients = inventory["clients"]
    scopes = inventory["client_scopes"]
    roles = inventory["realm_roles"]
    groups = inventory["groups"]

    client_addresses: dict[str, str] = {}
    for client in clients:
        if client.get("id"):
            resource_type = (
                "keycloak_saml_client"
                if client.get("protocol") == "saml"
                else "keycloak_openid_client"
            )
            client_addresses[client["id"]] = resource_address(
                resource_type, tf_name("client", client["id"])
            )

    scope_addresses = {
        scope["id"]: resource_address(
            "keycloak_saml_client_scope"
            if scope.get("protocol") == "saml"
            else "keycloak_openid_client_scope",
            tf_name("scope", scope["id"]),
        )
        for scope in scopes
        if scope.get("id")
    }
    role_addresses = {
        role["id"]: resource_address("keycloak_role", tf_name("role", role["id"]))
        for role in roles
        if role.get("id")
    }
    group_addresses = {
        group["id"]: resource_address("keycloak_group", tf_name("group", group["id"]))
        for group in groups
        if group.get("id")
    }

    resources: list[str] = [
        "# Generated from the homelab Keycloak API. Review before promoting to root Terraform files.",
        "# Client secrets, users, and passwords are intentionally excluded.",
        "",
    ]
    imports: list[str] = [
        "# Generated import declarations. Review before applying.",
        "",
    ]
    skipped: list[str] = []

    for client in clients:
        client_id = client.get("id")
        client_key = client.get("clientId")
        if not client_id or not client_key:
            skipped.append(f"client without id or clientId: {client!r}")
            continue
        address = client_addresses[client_id]
        resource_type, name = address.split(".", 1)
        imported = plan_state.get(address, {})
        body: list[str] = []
        add_reference(body, "realm_id", "keycloak_realm.homelab.id")
        add_arg(body, "client_id", client_key)
        add_arg(body, "name", client.get("name"))
        add_arg(body, "description", client.get("description"))
        add_arg(body, "enabled", client.get("enabled"))

        if resource_type == "keycloak_openid_client":
            access_type = "BEARER-ONLY" if client.get("bearerOnly") else "PUBLIC" if client.get("publicClient") else "CONFIDENTIAL"
            add_arg(body, "access_type", access_type)
            field_map = {
                "standardFlowEnabled": "standard_flow_enabled",
                "implicitFlowEnabled": "implicit_flow_enabled",
                "directAccessGrantsEnabled": "direct_access_grants_enabled",
                "serviceAccountsEnabled": "service_accounts_enabled",
                "frontchannelLogout": "frontchannel_logout_enabled",
                "fullScopeAllowed": "full_scope_allowed",
                "consentRequired": "consent_required",
                "rootUrl": "root_url",
                "adminUrl": "admin_url",
                "baseUrl": "base_url",
                "redirectUris": "valid_redirect_uris",
                "webOrigins": "web_origins",
                "clientAuthenticatorType": "client_authenticator_type",
            }
            for source, target in field_map.items():
                if source in client and client[source] is not None:
                    add_arg(body, target, client[source])
            if imported.get("use_refresh_tokens") is not None:
                add_arg(body, "use_refresh_tokens", imported["use_refresh_tokens"])
            if imported.get("use_refresh_tokens_client_credentials") is not None:
                add_arg(
                    body,
                    "use_refresh_tokens_client_credentials",
                    imported["use_refresh_tokens_client_credentials"],
                )
            authorization = imported.get("authorization")
            if isinstance(authorization, list) and authorization:
                authorization = authorization[0]
            if isinstance(authorization, dict) and authorization:
                body.append("  authorization {")
                for field in (
                    "policy_enforcement_mode",
                    "decision_strategy",
                    "allow_remote_resource_management",
                    "keep_defaults",
                ):
                    add_arg(body, field, authorization.get(field), "    ")
                body.append("  }")
            attributes = normalize_attributes(client.get("attributes"))
            if attributes:
                skipped.append(
                    f"OIDC client {client_key}: omitted API attributes from extra_config; review them manually"
                )
        else:
            field_map = {
                "includeAuthnStatement": "include_authn_statement",
                "signDocuments": "sign_documents",
                "signAssertions": "sign_assertions",
                "encryptAssertions": "encrypt_assertions",
                "clientSignatureRequired": "client_signature_required",
                "forcePostBinding": "force_post_binding",
                "frontChannelLogout": "front_channel_logout",
                "forceNameIdFormat": "force_name_id_format",
                "nameIdFormat": "name_id_format",
                "signatureAlgorithm": "signature_algorithm",
                "signatureKeyName": "signature_key_name",
                "canonicalizationMethod": "canonicalization_method",
                "rootUrl": "root_url",
                "baseUrl": "base_url",
                "assertionConsumerServicePostBindingUrl": "assertion_consumer_post_url",
                "assertionConsumerServiceRedirectBindingUrl": "assertion_consumer_redirect_url",
                "logoutServicePostBindingUrl": "logout_service_post_binding_url",
                "logoutServiceRedirectBindingUrl": "logout_service_redirect_binding_url",
            }
            for source, target in field_map.items():
                if source in client and client[source] is not None:
                    add_arg(body, target, client[source])
            if client.get("signingPrivateKey"):
                skipped.append(f"SAML client {client_key}: signing private key requires manual review")
                continue

        body.extend(["", "  lifecycle {", "    prevent_destroy = true", "  }"])
        resources.append(resource_block(resource_type, name, body))
        imports.append(import_block(address, f"{realm}/{client_id}"))

    for scope in scopes:
        scope_id = scope.get("id")
        if not scope_id:
            skipped.append(f"client scope without id: {scope!r}")
            continue
        address = scope_addresses[scope_id]
        resource_type, name = address.split(".", 1)
        imported = plan_state.get(address, {})
        body = ["  realm_id = keycloak_realm.homelab.id"]
        add_arg(body, "name", scope.get("name"))
        add_arg(body, "description", scope.get("description"))
        consent_screen_text = imported.get("consent_screen_text")
        if consent_screen_text is None:
            consent_screen_text = scope.get("consentScreenText")
        add_arg(body, "consent_screen_text", consent_screen_text)
        if resource_type == "keycloak_openid_client_scope":
            include_in_token_scope = imported.get("include_in_token_scope")
            if include_in_token_scope is None:
                include_in_token_scope = scope.get("includeInTokenScope")
            include_in_openid_provider_metadata = imported.get("include_in_openid_provider_metadata")
            if include_in_openid_provider_metadata is None:
                include_in_openid_provider_metadata = scope.get("includeInOpenidProviderMetadata")
            add_arg(body, "include_in_token_scope", include_in_token_scope)
            add_arg(body, "include_in_openid_provider_metadata", include_in_openid_provider_metadata)
        gui_order = imported.get("gui_order")
        if gui_order is None:
            gui_order = scope.get("guiOrder")
        add_arg(body, "gui_order", gui_order)
        attributes = normalize_attributes(scope.get("attributes"))
        if attributes:
            skipped.append(
                f"client scope {scope.get('name')}: omitted API attributes from extra_config; review them manually"
            )
        resources.append(resource_block(resource_type, name, body))
        imports.append(import_block(address, f"{realm}/{scope_id}"))

    for role in roles:
        role_id = role.get("id")
        role_name = role.get("name")
        if not role_id or not role_name:
            skipped.append(f"role without id or name: {role!r}")
            continue
        address = role_addresses[role_id]
        _, name = address.split(".", 1)
        body = ["  realm_id = keycloak_realm.homelab.id"]
        container_id = role.get("containerId")
        if role.get("clientRole") and container_id in client_addresses:
            add_reference(body, "client_id", f"{client_addresses[container_id]}.id")
        add_arg(body, "name", role_name)
        add_arg(body, "description", role.get("description"))
        attributes = normalize_attributes(role.get("attributes"))
        if attributes:
            add_arg(body, "attributes", attributes)
        composite_ids = [
            composite_id
            for composite_id in (role.get("composites", {}).get("realm", []) or [])
            if composite_id in role_addresses
        ]
        if composite_ids:
            body.append("  composite_roles = [")
            body.extend(f"    {role_addresses[item]}.id," for item in composite_ids)
            body.append("  ]")
        body.extend(["", "  lifecycle {", "    ignore_changes = [composite_roles]", "  }"])
        resources.append(resource_block("keycloak_role", name, body))
        imports.append(import_block(address, f"{realm}/{role_id}"))

    for group in groups:
        group_id = group.get("id")
        group_name = group.get("name")
        if not group_id or group_name is None:
            skipped.append(f"group without id or name: {group!r}")
            continue
        address = group_addresses[group_id]
        _, name = address.split(".", 1)
        body = ["  realm_id = keycloak_realm.homelab.id"]
        parent_id = group.get("parent_id")
        if parent_id in group_addresses:
            add_reference(body, "parent_id", f"{group_addresses[parent_id]}.id")
        add_arg(body, "name", group_name)
        attributes = normalize_attributes(group.get("attributes"))
        if attributes:
            add_arg(body, "attributes", attributes)
        resources.append(resource_block("keycloak_group", name, body))
        imports.append(import_block(address, f"{realm}/{group_id}"))

        mappings = inventory["group_role_mappings"].get(group_id, {})
        mapped_ids = {
            role.get("id")
            for role in mappings.get("realmMappings", [])
            if role.get("id") in role_addresses
        }
        for client_mapping in (mappings.get("clientMappings", {}) or {}).values():
            mapped_ids.update(
                role.get("id")
                for role in client_mapping.get("mappings", [])
                if role.get("id") in role_addresses
            )
        mapped_ids = sorted(item for item in mapped_ids if item)
        if mapped_ids:
            mapping_name = tf_name("group_roles", group_id)
            mapping_address = resource_address("keycloak_group_roles", mapping_name)
            mapping_body = [
                "  realm_id = keycloak_realm.homelab.id",
                f"  group_id = {address}.id",
                "  # The provider refreshes this attribute as true. Keep it authoritative to avoid perpetual drift.",
                "  exhaustive = true",
                "  role_ids = [",
            ]
            mapping_body.extend(f"    {role_addresses[item]}.id," for item in mapped_ids)
            mapping_body.append("  ]")
            resources.append(resource_block("keycloak_group_roles", mapping_name, mapping_body))
            imports.append(import_block(mapping_address, f"{realm}/{group_id}"))

    def add_mappers(mappers: dict[str, list[dict[str, Any]]], parent_addresses: dict[str, str], parent_segment: str) -> None:
        for parent_id, mapper_list in mappers.items():
            parent_address = parent_addresses.get(parent_id)
            if not parent_address:
                continue
            for mapper in mapper_list:
                mapper_id = mapper.get("id")
                mapper_name = mapper.get("name")
                protocol = mapper.get("protocol")
                protocol_mapper = mapper.get("protocolMapper")
                if not mapper_id or not mapper_name or protocol not in {"openid-connect", "saml"} or not protocol_mapper:
                    skipped.append(f"unsupported protocol mapper: {mapper!r}")
                    continue
                name = tf_name("mapper", mapper_id)
                body = ["  realm_id = keycloak_realm.homelab.id"]
                if parent_segment == "client":
                    add_reference(body, "client_id", f"{parent_address}.id")
                else:
                    add_reference(body, "client_scope_id", f"{parent_address}.id")
                add_arg(body, "name", mapper_name)
                add_arg(body, "protocol", protocol)
                add_arg(body, "protocol_mapper", protocol_mapper)
                address = resource_address("keycloak_generic_protocol_mapper", name)
                mapper_state = plan_state.get(address, {})
                mapper_config = mapper_state.get("config")
                if not isinstance(mapper_config, dict):
                    mapper_config = normalize_attributes(mapper.get("config"))
                add_arg(body, "config", mapper_config)
                resources.append(resource_block("keycloak_generic_protocol_mapper", name, body))
                imports.append(import_block(address, f"{realm}/{parent_segment}/{parent_id}/{mapper_id}"))

    add_mappers(inventory["client_protocol_mappers"], client_addresses, "client")
    add_mappers(inventory["scope_protocol_mappers"], scope_addresses, "client-scope")

    return "\n".join(resources), "\n".join(imports), skipped


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--realm", default="homelab", help="Realm to discover (default: homelab)")
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("migrations/adoption/generated"),
        help="Directory for inventory and generated Terraform (default: migrations/adoption/generated)",
    )
    parser.add_argument(
        "--plan-json",
        type=Path,
        help="Optional terraform show -json output used to preserve imported provider state",
    )
    args = parser.parse_args()

    try:
        api = KeycloakApi()
        inventory = collect_inventory(api, args.realm)
        resources, imports, skipped = generate_terraform(
            inventory,
            args.realm,
            load_plan_state(args.plan_json),
        )
    except (RuntimeError, KeyError, HTTPError, URLError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1

    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "inventory.json").write_text(
        json.dumps(inventory, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    (args.output_dir / "resources.tf").write_text(resources, encoding="utf-8")
    (args.output_dir / "imports.tf").write_text(imports, encoding="utf-8")
    (args.output_dir / "skipped.txt").write_text(
        "\n".join(skipped) + ("\n" if skipped else ""), encoding="utf-8"
    )
    print(f"Wrote discovery output to {args.output_dir}")
    print(f"  resources: {args.output_dir / 'resources.tf'}")
    print(f"  imports:   {args.output_dir / 'imports.tf'}")
    print(f"  inventory: {args.output_dir / 'inventory.json'}")
    if skipped:
        print(f"  skipped:   {len(skipped)} items recorded in {args.output_dir / 'skipped.txt'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
