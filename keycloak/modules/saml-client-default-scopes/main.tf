resource "keycloak_saml_client_default_scopes" "this" {
  realm_id       = var.realm_id
  client_id      = var.client_id
  default_scopes = var.default_scopes
}
