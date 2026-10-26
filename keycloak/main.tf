module "realms" {
  source  = "./stacks/realms"
  tenants = local.tenants
}
