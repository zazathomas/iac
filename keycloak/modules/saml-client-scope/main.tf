resource "keycloak_saml_client_scope" "this" {
  realm_id            = var.realm_id
  name                = var.scope.name
  description         = try(var.scope.description, null)
  consent_screen_text = try(var.scope.consent_screen_text, null)
  gui_order           = try(var.scope.gui_order, null)
}

output "scope_id" {
  description = "Provider resource ID for the SAML client scope."
  value       = keycloak_saml_client_scope.this.id
}

output "scope_name" {
  value = keycloak_saml_client_scope.this.name
}
