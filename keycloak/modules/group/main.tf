resource "keycloak_group" "this" {
  realm_id   = var.realm_id
  name       = var.group.name
  parent_id  = try(var.group.parent_id, null)
  attributes = var.group.attributes

  lifecycle {
    prevent_destroy = false
  }
}

output "group_id" {
  description = "Provider resource ID for the group."
  value       = keycloak_group.this.id
}
