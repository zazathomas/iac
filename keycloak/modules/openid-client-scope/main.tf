resource "keycloak_openid_client_scope" "this" {
  realm_id                            = var.realm_id
  name                                = var.scope.name
  description                         = try(var.scope.description, null)
  consent_screen_text                 = try(var.scope.consent_screen_text, null)
  include_in_token_scope              = var.scope.include_in_token_scope
  include_in_openid_provider_metadata = var.scope.include_in_openid_provider_metadata
  gui_order                           = try(var.scope.gui_order, null)
}

output "scope_id" {
  description = "Provider resource ID for the OpenID client scope."
  value       = keycloak_openid_client_scope.this.id
}

output "scope_name" {
  value = keycloak_openid_client_scope.this.name
}
