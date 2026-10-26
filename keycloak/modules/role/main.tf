resource "keycloak_role" "this" {
  realm_id    = var.realm_id
  name        = var.role.name
  client_id   = try(var.role.client_id, null)
  description = try(var.role.description, null)
  attributes  = var.role.attributes

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [composite_roles]
  }
}

output "role_id" {
  description = "Provider resource ID for the role."
  value       = keycloak_role.this.id
}
