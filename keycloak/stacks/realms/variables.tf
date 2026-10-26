variable "tenants" {
  description = "Tenant realm definitions keyed by stable tenant key. The tenant module owns the detailed schema."
  type        = map(any)
}
