resource "keycloak_saml_client" "this" {
  realm_id                  = var.realm_id
  client_id                 = var.client.client_id
  name                      = try(var.client.name, null)
  description               = try(var.client.description, null)
  enabled                   = var.client.enabled
  full_scope_allowed        = var.client.full_scope_allowed
  consent_required          = var.client.consent_required
  root_url                  = try(var.client.root_url, null)
  base_url                  = try(var.client.base_url, null)
  valid_redirect_uris       = var.client.valid_redirect_uris
  client_signature_required = true
  include_authn_statement   = true
  sign_documents            = false
  sign_assertions           = false
  force_post_binding        = true
  front_channel_logout      = true

  lifecycle {
    prevent_destroy = true
  }
}

output "client_id" {
  description = "Provider resource ID for the SAML client."
  value       = keycloak_saml_client.this.id
}
