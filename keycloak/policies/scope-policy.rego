package main

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client_optional_scopes"
  after := resource.change.after
  scope := after.optional_scopes[_]
  scope == "offline_access"
  msg := sprintf("client scope binding %q must not expose offline_access by default", [resource.address])
}
