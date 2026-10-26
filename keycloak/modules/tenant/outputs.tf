output "realm_id" {
  description = "Provider resource ID for the tenant realm."
  value       = module.realm.realm_id
}

output "ownership" {
  description = "Declared ownership boundaries for this tenant configuration."
  value       = var.tenant.ownership
}

output "client_ids" {
  description = "Provider resource IDs keyed by logical client key."
  value       = local.client_resource_ids
}

output "client_scope_ids" {
  description = "Provider resource IDs keyed by logical client-scope key."
  value = merge(
    { for key, scope in module.openid_scope : key => scope.scope_id },
    { for key, scope in module.saml_scope : key => scope.scope_id },
  )
}

output "role_ids" {
  description = "Provider resource IDs keyed by logical role key."
  value       = { for key, role in module.role : key => role.role_id }
}

output "group_ids" {
  description = "Provider resource IDs keyed by logical group key."
  value       = local.group_resource_ids
}
