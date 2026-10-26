resource "keycloak_realm" "this" {
  realm                            = var.realm.name
  enabled                          = var.realm.enabled
  terraform_deletion_protection    = true
  login_theme                      = var.realm.login_theme
  account_theme                    = var.realm.account_theme
  admin_theme                      = var.realm.admin_theme
  email_theme                      = var.realm.email_theme
  default_signature_algorithm      = var.realm.default_signature_algorithm
  ssl_required                     = try(var.security_baseline.ssl_required, null)
  registration_allowed             = try(var.security_baseline.registration_allowed, null)
  registration_email_as_username   = try(var.security_baseline.registration_email_as_username, null)
  edit_username_allowed            = try(var.security_baseline.edit_username_allowed, null)
  reset_password_allowed           = try(var.security_baseline.reset_password_allowed, null)
  remember_me                      = try(var.security_baseline.remember_me, null)
  verify_email                     = try(var.security_baseline.verify_email, null)
  login_with_email_allowed         = try(var.security_baseline.login_with_email_allowed, null)
  duplicate_emails_allowed         = try(var.security_baseline.duplicate_emails_allowed, null)
  password_policy                  = try(var.security_baseline.password_policy, null)
  sso_session_idle_timeout         = try(var.security_baseline.sso_session_idle_timeout, null)
  sso_session_max_lifespan         = try(var.security_baseline.sso_session_max_lifespan, null)
  access_token_lifespan            = try(var.security_baseline.access_token_lifespan, null)
  access_code_lifespan             = try(var.security_baseline.access_code_lifespan, null)
  access_code_lifespan_login       = try(var.security_baseline.access_code_lifespan_login, null)
  access_code_lifespan_user_action = try(var.security_baseline.access_code_lifespan_user_action, null)
  revoke_refresh_token             = try(var.security_baseline.revoke_refresh_token, null)
  refresh_token_max_reuse          = try(var.security_baseline.refresh_token_max_reuse, null)

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [smtp_server]
  }
}

output "realm_id" {
  description = "Provider resource ID for the realm."
  value       = keycloak_realm.this.id
}
