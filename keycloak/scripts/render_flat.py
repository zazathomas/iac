#!/usr/bin/env python3
"""Render explicit typed module blocks and module-addressed imports from a Keycloak inventory."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

try:
    from discover import load_plan_state, tf_name
except ImportError as error:  # pragma: no cover
    raise SystemExit("Run this script from keycloak/, for example: python3 scripts/render_flat.py") from error


def hcl(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2).replace("${", "$${")


def quote(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False).replace("${", "$${")


def import_block(address: str, identifier: str) -> str:
    return "\n".join(
        [
            "import {",
            f"  to = {address}",
            f"  id = {quote(identifier)}",
            "}",
            "",
        ]
    )


def old_address(resource_type: str, prefix: str, identifier: str) -> str:
    return f"{resource_type}.{tf_name(prefix, identifier)}"


def state_for(
    plan_state: dict[str, dict[str, Any]],
    resource_type: str,
    prefix: str,
    identifier: str,
) -> dict[str, Any]:
    return plan_state.get(old_address(resource_type, prefix, identifier), {})


def safe_name(*parts: str) -> str:
    value = "_".join(re.sub(r"[^0-9A-Za-z]+", "_", part).strip("_") for part in parts)
    value = re.sub(r"_+", "_", value).lower()
    return value if value and not value[0].isdigit() else f"item_{value}"


def client_key(tenant_key: str, client_id: str) -> str:
    return f"{tenant_key}/{client_id}"


def scope_key(tenant_key: str, name: str) -> str:
    return f"{tenant_key}/{name}"


def role_key(tenant_key: str, client_id: str | None, name: str) -> str:
    return f"{tenant_key}/{client_id}/{name}" if client_id else f"{tenant_key}/{name}"


def group_key(tenant_key: str, path: str) -> str:
    return f"{tenant_key}/group{path}"


def module_block(name: str, source: str, arguments: list[str]) -> str:
    body = [f'module "{name}" {{', f'  source = "./modules/{source}"']
    body.extend(f"  {argument}" for argument in arguments)
    body.extend(["}", ""])
    return "\n".join(body)


def object_argument(name: str, value: dict[str, Any]) -> str:
    return f"{name} = {hcl(value)}"


def raw_object_argument(name: str, fields: list[str]) -> str:
    return f"{name} = {{\n" + "\n".join(f"    {field}" for field in fields) + "\n  }"


def expression_list_argument(name: str, expressions: list[str]) -> str:
    if not expressions:
        return f"{name} = []"
    return f"{name} = [\n" + "\n".join(f"    {expression}," for expression in expressions) + "\n  ]"


def output_map(name: str, entries: dict[str, str], description: str) -> str:
    lines = [f'output "{name}" {{', f'  description = {quote(description)}', "  value = {"]
    lines.extend(f"    {quote(key)} = {expression}" for key, expression in sorted(entries.items()))
    lines.extend(["  }", "}", ""])
    return "\n".join(lines)


def render(
    inventory: dict[str, Any],
    plan_state: dict[str, dict[str, Any]],
    realm: str,
    tenant_key: str,
) -> tuple[dict[str, str], str]:
    clients = {client["clientId"]: client for client in inventory["clients"]}
    scopes = {scope["name"]: scope for scope in inventory["client_scopes"]}
    client_ids_by_id = {client["id"]: client["clientId"] for client in clients.values()}
    client_keys_by_id = {client["id"]: client_key(tenant_key, client["clientId"]) for client in clients.values()}
    scope_keys_by_name = {name: scope_key(tenant_key, name) for name in scopes}

    realm_module = safe_name(tenant_key, "realm")
    client_modules: dict[str, str] = {}
    scope_modules: dict[str, str] = {}
    role_modules: dict[str, str] = {}
    group_modules: dict[str, str] = {}
    group_parent_keys: dict[str, str | None] = {}

    realm_tf = module_block(
        realm_module,
        "realm",
        [
            object_argument(
                "realm",
                {
                    "name": realm,
                    "enabled": True,
                    "login_theme": "z3cyber-keycloak-theme",
                    "account_theme": "z3cyber-keycloak-theme",
                    "admin_theme": "z3cyber-keycloak-theme",
                    "email_theme": "z3cyber-keycloak-theme",
                    "default_signature_algorithm": "RS256",
                },
            )
        ],
    )

    client_values: dict[str, dict[str, Any]] = {}
    client_mappers: dict[str, dict[str, Any]] = {}
    client_tf: list[str] = []
    binding_specs: list[dict[str, Any]] = []
    binding_tf: list[str] = []
    imports: list[str] = [
        "# Imports target explicit per-item module addresses. Remove this file after the adoption apply if desired.",
        import_block(f"module.{realm_module}.keycloak_realm.this", realm),
    ]

    for client_id, client in clients.items():
        key = client_key(tenant_key, client_id)
        imported = state_for(
            plan_state,
            "keycloak_saml_client" if client.get("protocol") == "saml" else "keycloak_openid_client",
            "client",
            client["id"],
        )
        value: dict[str, Any] = {
            "tenant_key": tenant_key,
            "client_key": key,
            "client_id": client_id,
            "protocol": client.get("protocol", "openid-connect"),
            "name": client.get("name"),
            "description": client.get("description"),
            "enabled": client.get("enabled", True),
            "access_type": (
                "BEARER-ONLY"
                if client.get("bearerOnly")
                else "PUBLIC"
                if client.get("publicClient")
                else "CONFIDENTIAL"
            ),
            "standard_flow_enabled": client.get("standardFlowEnabled", False),
            "implicit_flow_enabled": client.get("implicitFlowEnabled", False),
            "direct_access_grants_enabled": client.get("directAccessGrantsEnabled", False),
            "service_accounts_enabled": client.get("serviceAccountsEnabled", False),
            "frontchannel_logout_enabled": client.get("frontchannelLogout", False),
            "full_scope_allowed": client.get("fullScopeAllowed", True),
            "consent_required": client.get("consentRequired", False),
            "root_url": client.get("rootUrl"),
            "admin_url": client.get("adminUrl"),
            "base_url": client.get("baseUrl"),
            "valid_redirect_uris": client.get("redirectUris", []),
            "valid_post_logout_redirect_uris": client.get("attributes", {}).get("post.logout.redirect.uris", []),
            "web_origins": client.get("webOrigins", []),
            "client_authenticator_type": client.get("clientAuthenticatorType"),
            "use_refresh_tokens": imported.get("use_refresh_tokens", False),
            "use_refresh_tokens_client_credentials": imported.get(
                "use_refresh_tokens_client_credentials", False
            ),
            "default_scope_refs": [scope_keys_by_name.get(name, name) for name in client.get("defaultClientScopes", [])],
            "optional_scope_refs": [scope_keys_by_name.get(name, name) for name in client.get("optionalClientScopes", [])],
        }
        authorization = imported.get("authorization")
        if isinstance(authorization, list) and authorization:
            authorization = authorization[0]
        if isinstance(authorization, dict) and authorization:
            value["authorization"] = {
                key: authorization.get(key)
                for key in (
                    "policy_enforcement_mode",
                    "decision_strategy",
                    "allow_remote_resource_management",
                    "keep_defaults",
                )
                if authorization.get(key) is not None
            }

        module_name = safe_name(
            tenant_key,
            client_id if client_id.endswith("-client") else f"{client_id}_client",
        )
        client_modules[key] = module_name
        if client.get("protocol") == "saml":
            client_config = {
                field: value[field]
                for field in (
                    "client_id",
                    "name",
                    "description",
                    "enabled",
                    "full_scope_allowed",
                    "consent_required",
                    "root_url",
                    "base_url",
                    "valid_redirect_uris",
                )
            }
            client_tf.append(
                module_block(
                    module_name,
                    "saml-client",
                    [
                        f"realm_id = module.{realm_module}.realm_id",
                        object_argument("client", client_config),
                    ],
                )
            )
            client_resource = "keycloak_saml_client.this"
        else:
            client_config = {
                field: value[field]
                for field in (
                    "client_id",
                    "name",
                    "description",
                    "enabled",
                    "access_type",
                    "standard_flow_enabled",
                    "implicit_flow_enabled",
                    "direct_access_grants_enabled",
                    "service_accounts_enabled",
                    "frontchannel_logout_enabled",
                    "full_scope_allowed",
                    "consent_required",
                    "root_url",
                    "admin_url",
                    "base_url",
                    "valid_redirect_uris",
                    "valid_post_logout_redirect_uris",
                    "web_origins",
                    "client_authenticator_type",
                    "use_refresh_tokens",
                    "use_refresh_tokens_client_credentials",
                    "authorization",
                )
                if field in value
            }
            client_tf.append(
                module_block(
                    module_name,
                    "openid-client",
                    [
                        f"realm_id = module.{realm_module}.realm_id",
                        object_argument("client", client_config),
                    ],
                )
            )
            client_resource = "keycloak_openid_client.this"
        imports.append(import_block(f"module.{module_name}.{client_resource}", f"{realm}/{client['id']}"))
        client_values[key] = value

        if value["default_scope_refs"]:
            binding_specs.append({
                "name": safe_name(tenant_key, client_id, "default_scopes"),
                "source": "saml-client-default-scopes" if client.get("protocol") == "saml" else "openid-client-default-scopes",
                "resource": "keycloak_saml_client_default_scopes.this" if client.get("protocol") == "saml" else "keycloak_openid_client_default_scopes.this",
                "client_module": module_name,
                "client_id": client["id"],
                "scope_refs": value["default_scope_refs"],
                "argument": "default_scopes",
            })
        if value["optional_scope_refs"] and client.get("protocol") == "openid-connect":
            binding_specs.append({
                "name": safe_name(tenant_key, client_id, "optional_scopes"),
                "source": "openid-client-optional-scopes",
                "resource": "keycloak_openid_client_optional_scopes.this",
                "client_module": module_name,
                "client_id": client["id"],
                "scope_refs": value["optional_scope_refs"],
                "argument": "optional_scopes",
            })

        for mapper in inventory["client_protocol_mappers"].get(client["id"], []):
            mapper_state = state_for(
                plan_state,
                "keycloak_generic_protocol_mapper",
                "mapper",
                mapper["id"],
            )
            mapper_key = f"{key}/{mapper['name']}"
            client_mappers[mapper_key] = {
                "client_key": key,
                "name": mapper["name"],
                "protocol": mapper["protocol"],
                "protocol_mapper": mapper["protocolMapper"],
                "config": mapper_state.get("config", mapper.get("config") or {}),
                "import_id": f"{realm}/client/{client['id']}/{mapper['id']}",
            }

    scope_values: dict[str, dict[str, Any]] = {}
    scope_tf: list[str] = []
    scope_mappers: dict[str, dict[str, Any]] = {}
    for name, scope in scopes.items():
        key = scope_key(tenant_key, name)
        resource_type = "keycloak_saml_client_scope" if scope.get("protocol") == "saml" else "keycloak_openid_client_scope"
        imported = state_for(plan_state, resource_type, "scope", scope["id"])
        value: dict[str, Any] = {
            "tenant_key": tenant_key,
            "scope_key": key,
            "name": name,
            "protocol": scope.get("protocol", "openid-connect"),
            "description": scope.get("description"),
            "consent_screen_text": imported.get("consent_screen_text", scope.get("consentScreenText")),
            "gui_order": imported.get("gui_order", scope.get("guiOrder")),
        }
        if resource_type == "keycloak_openid_client_scope":
            value["include_in_token_scope"] = imported.get("include_in_token_scope", scope.get("includeInTokenScope", True))
            value["include_in_openid_provider_metadata"] = imported.get(
                "include_in_openid_provider_metadata",
                scope.get("includeInOpenidProviderMetadata", True),
            )
        module_name = safe_name(tenant_key, name, "client_scope")
        scope_modules[key] = module_name
        scope_config = {
            field: value[field]
            for field in (
                "name",
                "description",
                "consent_screen_text",
                "include_in_token_scope",
                "include_in_openid_provider_metadata",
                "gui_order",
            )
            if field in value and (resource_type == "keycloak_openid_client_scope" or field not in {"include_in_token_scope", "include_in_openid_provider_metadata"})
        }
        scope_tf.append(
            module_block(
                module_name,
                "saml-client-scope" if resource_type == "keycloak_saml_client_scope" else "openid-client-scope",
                [
                    f"realm_id = module.{realm_module}.realm_id",
                    object_argument("scope", scope_config),
                ],
            )
        )
        imports.append(
            import_block(
                f"module.{module_name}.{resource_type}.this",
                f"{realm}/{scope['id']}",
            )
        )
        scope_values[key] = value
        for mapper in inventory["scope_protocol_mappers"].get(scope["id"], []):
            mapper_state = state_for(
                plan_state,
                "keycloak_generic_protocol_mapper",
                "mapper",
                mapper["id"],
            )
            mapper_key = f"{key}/{mapper['name']}"
            scope_mappers[mapper_key] = {
                "scope_key": key,
                "name": mapper["name"],
                "protocol": mapper["protocol"],
                "protocol_mapper": mapper["protocolMapper"],
                "config": mapper_state.get("config", mapper.get("config") or {}),
                "import_id": f"{realm}/client-scope/{scope['id']}/{mapper['id']}",
            }

    for binding in binding_specs:
        scope_expressions = [
            f"module.{scope_modules[scope_ref]}.scope_name" if scope_ref in scope_modules else quote(scope_ref)
            for scope_ref in binding["scope_refs"]
        ]
        binding_tf.append(
            module_block(
                binding["name"],
                binding["source"],
                [
                    f"realm_id = module.{realm_module}.realm_id",
                    f"client_id = module.{binding['client_module']}.client_id",
                    expression_list_argument(binding["argument"], scope_expressions),
                ],
            )
        )
        imports.append(
            import_block(
                f"module.{binding['name']}.{binding['resource']}",
                f"{realm}/{binding['client_id']}",
            )
        )

    role_keys_by_id: dict[str, str] = {}
    role_values: dict[str, dict[str, Any]] = {}
    role_tf: list[str] = []
    for role in inventory["realm_roles"]:
        client_id = client_ids_by_id.get(role.get("containerId")) if role.get("clientRole") else None
        client_ref = client_key(tenant_key, client_id) if client_id else None
        key = role_key(tenant_key, client_id, role["name"])
        role_keys_by_id[role["id"]] = key
        module_name = safe_name(tenant_key, client_id or "realm", role["name"], "role")
        role_modules[key] = module_name
        role_fields = [
            f"name = {quote(role['name'])}",
            f"description = {quote(role.get('description') or None)}",
            f"attributes = {hcl(role.get('attributes') or {})}",
        ]
        if client_ref:
            role_fields.insert(1, f"client_id = module.{client_modules[client_ref]}.client_id")
        role_arguments = [
            f"realm_id = module.{realm_module}.realm_id",
            raw_object_argument("role", role_fields),
        ]
        role_tf.append(module_block(module_name, "role", role_arguments))
        role_values[key] = {"tenant_key": tenant_key, "client_key": client_ref, "name": role["name"]}
        imports.append(import_block(f"module.{module_name}.keycloak_role.this", f"{realm}/{role['id']}"))

    group_values: dict[str, dict[str, Any]] = {}
    group_tf: list[str] = []
    group_role_tf: list[str] = []
    group_role_imports: list[str] = []
    group_keys_by_id = {group["id"]: group_key(tenant_key, group["path"]) for group in inventory["groups"]}
    for group in inventory["groups"]:
        key = group_keys_by_id[group["id"]]
        parent_key = group_keys_by_id.get(group.get("parent_id"))
        group_parent_keys[key] = parent_key
        module_name = safe_name(tenant_key, group["path"].strip("/"), "group")
        group_modules[key] = module_name
        group_values[key] = {
            "tenant_key": tenant_key,
            "name": group["name"],
            "parent_key": parent_key,
            "attributes": group.get("attributes") or {},
        }
        group_config: dict[str, Any] = {"name": group["name"], "attributes": group.get("attributes") or {}}
        group_args = [f"realm_id = module.{realm_module}.realm_id"]
        if parent_key:
            group_args.append(f"group = {{\n    name = {quote(group['name'])}\n    parent_id = module.{group_modules[parent_key]}.group_id\n    attributes = {hcl(group.get('attributes') or {})}\n  }}")
        else:
            group_args.append(object_argument("group", group_config))
        group_tf.append(module_block(module_name, "group", group_args))
        resource_name = "keycloak_group.this"
        imports.append(import_block(f"module.{module_name}.{resource_name}", f"{realm}/{group['id']}"))

        mapping = inventory["group_role_mappings"].get(group["id"], {})
        mapped_role_keys: list[str] = []
        for mapped_role in mapping.get("realmMappings", []):
            if mapped_role.get("id") in role_keys_by_id:
                mapped_role_keys.append(role_keys_by_id[mapped_role["id"]])
        for client_mapping in (mapping.get("clientMappings", {}) or {}).values():
            for mapped_role in client_mapping.get("mappings", []):
                if mapped_role.get("id") in role_keys_by_id:
                    mapped_role_keys.append(role_keys_by_id[mapped_role["id"]])
        mapped_role_keys = sorted(set(mapped_role_keys))
        if mapped_role_keys:
            mapping_name = safe_name(tenant_key, group["path"].strip("/"), "group_roles")
            role_expressions = [f"module.{role_modules[role_ref]}.role_id" for role_ref in mapped_role_keys]
            group_role_tf.append(
                module_block(
                    mapping_name,
                    "group-roles",
                    [
                        f"realm_id = module.{realm_module}.realm_id",
                        f"group_id = module.{module_name}.group_id",
                        expression_list_argument("role_ids", role_expressions),
                    ],
                )
            )
            group_role_imports.append(
                import_block(f"module.{mapping_name}.keycloak_group_roles.this", f"{realm}/{group['id']}")
            )

    mapper_tf: list[str] = []
    mapper_imports: list[str] = []
    for mapper_key, mapper in client_mappers.items():
        module_name = safe_name(tenant_key, mapper["client_key"].split("/", 1)[1], mapper["name"], "client_mapper")
        mapper_tf.append(
            module_block(
                module_name,
                "protocol-mapper",
                [
                    f"realm_id = module.{realm_module}.realm_id",
                    f"client_id = module.{client_modules[mapper['client_key']]}.client_id",
                    object_argument(
                        "mapper",
                        {
                            "name": mapper["name"],
                            "protocol": mapper["protocol"],
                            "protocol_mapper": mapper["protocol_mapper"],
                            "config": mapper["config"],
                        },
                    ),
                ],
            )
        )
        mapper_imports.append(import_block(f"module.{module_name}.keycloak_generic_protocol_mapper.this", mapper["import_id"]))
    for mapper_key, mapper in scope_mappers.items():
        module_name = safe_name(tenant_key, mapper["scope_key"].split("/", 1)[1], mapper["name"], "scope_mapper")
        mapper_tf.append(
            module_block(
                module_name,
                "protocol-mapper",
                [
                    f"realm_id = module.{realm_module}.realm_id",
                    f"client_scope_id = module.{scope_modules[mapper['scope_key']]}.scope_id",
                    object_argument(
                        "mapper",
                        {
                            "name": mapper["name"],
                            "protocol": mapper["protocol"],
                            "protocol_mapper": mapper["protocol_mapper"],
                            "config": mapper["config"],
                        },
                    ),
                ],
            )
        )
        mapper_imports.append(import_block(f"module.{module_name}.keycloak_generic_protocol_mapper.this", mapper["import_id"]))

    client_output = {key: f"module.{module_name}.client_id" for key, module_name in client_modules.items()}
    scope_output = {key: f"module.{module_name}.scope_id" for key, module_name in scope_modules.items()}
    role_output = {key: f"module.{module_name}.role_id" for key, module_name in role_modules.items()}
    group_output = {key: f"module.{module_name}.group_id" for key, module_name in group_modules.items()}
    outputs_tf = "\n".join(
        [
            output_map("tenant_realm_ids", {tenant_key: f"module.{realm_module}.realm_id"}, "Keycloak realm IDs keyed by tenant key."),
            output_map("client_ids", client_output, "Keycloak client IDs keyed by compound tenant/client key."),
            output_map("client_scope_ids", scope_output, "Keycloak client scope IDs keyed by compound tenant/scope key."),
            output_map("role_ids", role_output, "Keycloak role IDs keyed by compound tenant/role key."),
            output_map("group_ids", group_output, "Keycloak group IDs keyed by compound tenant/group key."),
        ]
    )

    files = {
        "tenants.tf": realm_tf,
        "clients.tf": "\n".join(client_tf),
        "client_scopes.tf": "\n".join(scope_tf),
        "client_scope_bindings.tf": "\n".join(binding_tf),
        "roles.tf": "\n".join(role_tf),
        "groups.tf": "\n".join(group_tf),
        "group_roles.tf": "\n".join(group_role_tf),
        "protocol_mappers.tf": "\n".join(mapper_tf),
        "outputs.tf": outputs_tf,
    }
    imports.extend(group_role_imports)
    imports.extend(mapper_imports)
    return files, "\n".join(imports)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--inventory",
        type=Path,
        default=Path("migrations/adoption/generated/inventory.json"),
        help="Adoption inventory path (default: migrations/adoption/generated/inventory.json)",
    )
    parser.add_argument("--plan-json", type=Path, default=Path("/tmp/keycloak-plan.json"))
    parser.add_argument("--realm", default="homelab")
    parser.add_argument("--tenant-key", default=None)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("migrations/adoption/rendered"),
        help="Migration output directory; never use this as canonical configuration",
    )
    args = parser.parse_args()

    inventory = json.loads(args.inventory.read_text(encoding="utf-8"))
    plan_state = load_plan_state(args.plan_json) if args.plan_json.exists() else {}
    files, imports = render(inventory, plan_state, args.realm, args.tenant_key or args.realm)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for name, content in files.items():
        (args.output_dir / name).write_text(content, encoding="utf-8")
    (args.output_dir / "imports.tf").write_text(imports, encoding="utf-8")
    print(f"Wrote {len(files) + 1} files under {args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
