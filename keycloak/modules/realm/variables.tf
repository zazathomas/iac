variable "realm" {
  description = "Realm identity and presentation settings."

  type = object({
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
}

variable "security_baseline" {
  description = "Security settings owned by the platform security team."
  type = object({
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
  })
  default = {}

  validation {
    condition     = var.security_baseline.ssl_required == null || contains(["none", "external", "all"], var.security_baseline.ssl_required)
    error_message = "security_baseline.ssl_required must be none, external, or all."
  }
}
