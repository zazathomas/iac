resource "cloudflare_zone" "this" {
  name = "z3cyber.tech"

  account = {
    id = var.cloudflare_account_id
  }

  type = "full"

  lifecycle {
    prevent_destroy = true
  }
}

# The zone already exists. Terraform will import it using the zone ID supplied
# in terraform.tfvars before managing it going forward.
import {
  to = cloudflare_zone.this
  id = var.cloudflare_zone_id
}
