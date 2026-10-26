variable "realm_id" {
  type = string
}

variable "client" {
  type = object({
    client_id                             = string
    name                                  = optional(string)
    description                           = optional(string)
    enabled                               = optional(bool, true)
    access_type                           = optional(string, "CONFIDENTIAL")
    standard_flow_enabled                 = optional(bool, false)
    implicit_flow_enabled                 = optional(bool, false)
    direct_access_grants_enabled          = optional(bool, false)
    service_accounts_enabled              = optional(bool, false)
    frontchannel_logout_enabled           = optional(bool, false)
    full_scope_allowed                    = optional(bool, false)
    consent_required                      = optional(bool, false)
    root_url                              = optional(string)
    admin_url                             = optional(string)
    base_url                              = optional(string)
    valid_redirect_uris                   = optional(list(string), [])
    valid_post_logout_redirect_uris       = optional(list(string), [])
    web_origins                           = optional(list(string), [])
    client_authenticator_type             = optional(string)
    pkce_code_challenge_method            = optional(string)
    use_refresh_tokens                    = optional(bool, false)
    use_refresh_tokens_client_credentials = optional(bool, false)
    authorization = optional(object({
      policy_enforcement_mode          = string
      decision_strategy                = optional(string)
      allow_remote_resource_management = optional(bool)
      keep_defaults                    = optional(bool)
    }))
  })

  validation {
    condition     = contains(["CONFIDENTIAL", "PUBLIC", "BEARER-ONLY"], var.client.access_type)
    error_message = "access_type must be CONFIDENTIAL, PUBLIC, or BEARER-ONLY."
  }

  validation {
    condition     = var.client.pkce_code_challenge_method == null || contains(["", "S256", "plain"], var.client.pkce_code_challenge_method)
    error_message = "pkce_code_challenge_method must be null, empty, S256, or plain."
  }
}
