package main

# Stable logical keys are enforced in the tenant model. These plan checks catch
# provider resources that would still be difficult to identify operationally.

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_openid_client"
  after := resource.change.after
  after.client_id == ""
  msg := sprintf("client resource %q has an empty client_id", [resource.address])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "keycloak_role"
  after := resource.change.after
  after.name == ""
  msg := sprintf("role resource %q has an empty name", [resource.address])
}
