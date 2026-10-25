terraform {
  required_version = ">= 1.5.0"

  backend "remote" {
    hostname     = "terrapod.z3cyber.tech"
    organization = "default"

    workspaces {
      name = "cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.19.1"
    }
  }
}

# The provider reads CLOUDFLARE_API_TOKEN from the environment.
provider "cloudflare" {}
