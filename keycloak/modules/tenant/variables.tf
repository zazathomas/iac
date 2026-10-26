variable "tenant" {
  description = "Declarative identity configuration for one Keycloak realm."

  type = object({
    realm = object({
      name                        = string
      enabled                     = bool
      login_theme                 = string
      account_theme               = string
      admin_theme                 = string
      email_theme                 = string
      default_signature_algorithm = string
      security_baseline = optional(object({
        ssl_required                     = optional(string)
        registration_allowed             = optional(bool)
        registration_email_as_username   = optional(bool)
        edit_username_allowed            = optional(bool)
        reset_password_allowed           = optional(bool)
        remember_me                      = optional(bool)
        verify_email                     = optional(bool)
        login_with_email_allowed         = optional(bool)
        duplicate_emails_allowed         = optional(bool)
        password_policy                  = optional(string)
        sso_session_idle_timeout         = optional(string)
        sso_session_max_lifespan         = optional(string)
        access_token_lifespan            = optional(string)
        access_code_lifespan             = optional(string)
        access_code_lifespan_login       = optional(string)
        access_code_lifespan_user_action = optional(string)
        revoke_refresh_token             = optional(bool)
        refresh_token_max_reuse          = optional(number)
      }), {})
    })

    ownership = optional(object({
      realm        = optional(string, "identity-platform")
      security     = optional(string, "platform-security")
      applications = optional(string, "application-owner")
      identities   = optional(string, "identity-source")
    }), {})

    clients = map(object({
      protocol                              = optional(string, "openid-connect")
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
      default_scopes  = optional(list(string), [])
      optional_scopes = optional(list(string), [])
    }))

    client_scopes = map(object({
      protocol                            = optional(string, "openid-connect")
      name                                = string
      description                         = optional(string)
      consent_screen_text                 = optional(string)
      include_in_token_scope              = optional(bool, false)
      include_in_openid_provider_metadata = optional(bool, false)
      gui_order                           = optional(number)
    }))

    roles = map(object({
      name        = string
      client_key  = optional(string)
      description = optional(string)
      attributes  = optional(map(string), {})
    }))

    groups = map(object({
      name       = string
      parent_key = optional(string)
      attributes = optional(map(string), {})
    }))

    group_roles = map(object({
      group_key  = string
      role_keys  = list(string)
      exhaustive = optional(bool, true)
    }))

    protocol_mappers = map(object({
      target_type     = string
      target_key      = string
      name            = string
      protocol        = string
      protocol_mapper = string
      config          = map(string)
    }))
  })

  validation {
    condition = alltrue([
      for client in values(var.tenant.clients) : contains(["openid-connect", "saml"], client.protocol)
    ])
    error_message = "Each client protocol must be openid-connect or saml."
  }

  validation {
    condition = alltrue([
      for scope in values(var.tenant.client_scopes) : contains(["openid-connect", "saml"], scope.protocol)
    ])
    error_message = "Each client scope protocol must be openid-connect or saml."
  }

  validation {
    condition = alltrue([
      for mapper in values(var.tenant.protocol_mappers) : contains(["client", "client_scope"], mapper.target_type)
    ])
    error_message = "Protocol mapper target_type must be client or client_scope."
  }

  validation {
    condition = alltrue([
      for group in values(var.tenant.groups) : try(
        group.parent_key == null || (
          contains(keys(var.tenant.groups), group.parent_key)
          && try(var.tenant.groups[group.parent_key].parent_key == null, false)
        ),
        false,
      )
    ])
    error_message = "Each group parent_key must reference a declared top-level group."
  }

  validation {
    condition = alltrue([
      for binding in values(var.tenant.group_roles) : try(
        contains(keys(var.tenant.groups), binding.group_key) && alltrue([
          for role_key in binding.role_keys : contains(keys(var.tenant.roles), role_key)
        ]),
        false,
      )
    ])
    error_message = "Group role bindings must reference declared groups and roles."
  }

  validation {
    condition = alltrue([
      for role in values(var.tenant.roles) : try(
        role.client_key == null || contains(keys(var.tenant.clients), role.client_key),
        false,
      )
    ])
    error_message = "Each role client_key must reference a declared client."
  }

  validation {
    condition = alltrue([
      for mapper in values(var.tenant.protocol_mappers) : try(
        mapper.target_type == "client"
        ? contains(keys(var.tenant.clients), mapper.target_key)
        : contains(keys(var.tenant.client_scopes), mapper.target_key),
        false,
      )
    ])
    error_message = "Protocol mappers must reference a declared client or client scope."
  }
}
