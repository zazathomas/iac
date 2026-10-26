resource "keycloak_openid_client_optional_scopes" "this" {
  realm_id        = var.realm_id
  client_id       = var.client_id
  optional_scopes = var.optional_scopes
}
