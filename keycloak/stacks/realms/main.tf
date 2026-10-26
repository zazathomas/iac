module "tenant" {
  for_each = var.tenants
  source   = "../../modules/tenant"
  tenant   = each.value
}
