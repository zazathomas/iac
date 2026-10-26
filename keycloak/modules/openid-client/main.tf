resource "keycloak_openid_client" "this" {
  realm_id                              = var.realm_id
  client_id                             = var.client.client_id
  name                                  = try(var.client.name, null)
  description                           = try(var.client.description, null)
  enabled                               = var.client.enabled
  access_type                           = var.client.access_type
  standard_flow_enabled                 = var.client.standard_flow_enabled
  implicit_flow_enabled                 = var.client.implicit_flow_enabled
  direct_access_grants_enabled          = var.client.direct_access_grants_enabled
  service_accounts_enabled              = var.client.service_accounts_enabled
  frontchannel_logout_enabled           = var.client.frontchannel_logout_enabled
  full_scope_allowed                    = var.client.full_scope_allowed
  consent_required                      = var.client.consent_required
  root_url                              = try(var.client.root_url, null)
  admin_url                             = try(var.client.admin_url, null)
  base_url                              = try(var.client.base_url, null)
  valid_redirect_uris                   = var.client.valid_redirect_uris
  valid_post_logout_redirect_uris       = var.client.valid_post_logout_redirect_uris
  web_origins                           = var.client.web_origins
  client_authenticator_type             = try(var.client.client_authenticator_type, null)
  pkce_code_challenge_method            = try(var.client.pkce_code_challenge_method, null)
  use_refresh_tokens                    = var.client.use_refresh_tokens
  use_refresh_tokens_client_credentials = var.client.use_refresh_tokens_client_credentials

  dynamic "authorization" {
    for_each = try(var.client.authorization, null) == null ? [] : [var.client.authorization]
    content {
      policy_enforcement_mode          = authorization.value.policy_enforcement_mode
      decision_strategy                = authorization.value.decision_strategy
      allow_remote_resource_management = authorization.value.allow_remote_resource_management
      keep_defaults                    = authorization.value.keep_defaults
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

output "client_id" {
  description = "Provider resource ID for the client."
  value       = keycloak_openid_client.this.id
}

output "client_resource_id" {
  description = "Provider resource ID for the client."
  value       = keycloak_openid_client.this.id
}

output "configured_client_id" {
  description = "Configured OAuth client identifier."
  value       = var.client.client_id
}
