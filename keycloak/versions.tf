terraform {
  required_version = ">= 1.5.0"

  backend "remote" {
    hostname     = "terrapod.z3cyber.tech"
    organization = "default"

    workspaces {
      name = "keycloak"
    }
  }

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.10.0"
    }
  }
}
