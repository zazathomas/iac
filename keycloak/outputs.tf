output "tenant_realm_ids" {
  description = "Provider resource IDs keyed by tenant key."
  value       = module.realms.tenant_realm_ids
}

output "ownership" {
  description = "Declared ownership boundaries keyed by tenant."
  value       = module.realms.ownership
}

output "client_ids" {
  description = "Provider resource IDs keyed by tenant and logical client key."
  value       = module.realms.client_ids
}

output "client_scope_ids" {
  description = "Provider resource IDs keyed by tenant and logical scope key."
  value       = module.realms.client_scope_ids
}

output "role_ids" {
  description = "Provider resource IDs keyed by tenant and logical role key."
  value       = module.realms.role_ids
}

output "group_ids" {
  description = "Provider resource IDs keyed by tenant and logical group key."
  value       = module.realms.group_ids
}
