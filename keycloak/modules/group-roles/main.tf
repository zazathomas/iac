resource "keycloak_group_roles" "this" {
  realm_id   = var.realm_id
  group_id   = var.group_id
  role_ids   = var.role_ids
  exhaustive = var.exhaustive
}
