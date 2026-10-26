output "tenant_realm_ids" {
  description = "Provider resource IDs keyed by tenant key."
  value       = { for key, tenant in module.tenant : key => tenant.realm_id }
}

output "ownership" {
  description = "Declared ownership boundaries keyed by tenant."
  value       = { for key, tenant in module.tenant : key => tenant.ownership }
}

output "client_ids" {
  description = "Provider resource IDs keyed by tenant and logical client key."
  value = merge([
    for tenant_key, tenant in module.tenant : {
      for client_key, client_id in tenant.client_ids : "${tenant_key}/${client_key}" => client_id
    }
  ]...)
}

output "client_scope_ids" {
  description = "Provider resource IDs keyed by tenant and logical scope key."
  value = merge([
    for tenant_key, tenant in module.tenant : {
      for scope_key, scope_id in tenant.client_scope_ids : "${tenant_key}/${scope_key}" => scope_id
    }
  ]...)
}

output "role_ids" {
  description = "Provider resource IDs keyed by tenant and logical role key."
  value = merge([
    for tenant_key, tenant in module.tenant : {
      for role_key, role_id in tenant.role_ids : "${tenant_key}/${role_key}" => role_id
    }
  ]...)
}

output "group_ids" {
  description = "Provider resource IDs keyed by tenant and logical group key."
  value = merge([
    for tenant_key, tenant in module.tenant : {
      for group_key, group_id in tenant.group_ids : "${tenant_key}/${group_key}" => group_id
    }
  ]...)
}
