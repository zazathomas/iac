package main

# These policies intentionally fail the plan. Exceptions belong in the tenant
# input model and should be reviewed by platform security before being added.

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client"
  after := resource.change.after
  after.full_scope_allowed == true
  msg := sprintf("client %q must set full_scope_allowed=false", [after.client_id])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client"
  after := resource.change.after
  uri := after.valid_redirect_uris[_]
  contains(uri, "*")
  msg := sprintf("client %q has wildcard redirect URI %q", [after.client_id, uri])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client"
  after := resource.change.after
  origin := after.web_origins[_]
  origin == "*"
  msg := sprintf("client %q has wildcard web origin", [after.client_id])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client"
  after := resource.change.after
  after.direct_access_grants_enabled == true
  msg := sprintf("client %q enables direct access grants", [after.client_id])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client"
  after := resource.change.after
  after.access_type == "PUBLIC"
  after.pkce_code_challenge_method != "S256"
  msg := sprintf("public client %q must use PKCE S256", [after.client_id])
}
