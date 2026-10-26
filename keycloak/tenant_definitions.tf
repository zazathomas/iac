locals {
  # This is the engineer-facing identity model. Provider-specific resources are
  # created by stacks/realms and modules/tenant.
  tenants = {
    homelab = {
      ownership = {
        realm        = "identity-platform"
        security     = "platform-security"
        applications = "application-owners"
        identities   = "identity-source"
      }

      realm = {
        name                        = "homelab"
        enabled                     = true
        login_theme                 = "z3cyber-keycloak-theme"
        account_theme               = "z3cyber-keycloak-theme"
        admin_theme                 = "z3cyber-keycloak-theme"
        email_theme                 = "z3cyber-keycloak-theme"
        default_signature_algorithm = "RS256"
      }

      clients = {
        actual = {
          client_id                             = "actual"
          name                                  = "actual"
          description                           = ""
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["https://budget.local.z3cyber.tech/openid/callback"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = ["https://budget.local.z3cyber.tech"]
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "sample", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        argocd = {
          client_id                             = "argocd"
          name                                  = "Argocd Client"
          description                           = "Argocd OIDC Client"
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = []
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "sample", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        gateway = {
          client_id                             = "gateway-client"
          name                                  = "Gateway API Client"
          description                           = "This client is used to authenticate with the gateway api across all kubernetes clusters"
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = []
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        grafana = {
          client_id                             = "grafana"
          name                                  = "grafana"
          description                           = "Grafana OIDC Client"
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = "https://grafana.k8s.z3cyber.tech"
          admin_url                             = "https://grafana.k8s.z3cyber.tech"
          base_url                              = "https://grafana.k8s.z3cyber.tech"
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = ["https://grafana.k8s.z3cyber.tech"]
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "groups", "basic", "sample", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        karakeep = {
          client_id                             = "karakeep-client"
          name                                  = ""
          description                           = ""
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = []
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        kubernetes = {
          client_id                             = "kubernetes"
          name                                  = "kubernetes"
          description                           = ""
          enabled                               = true
          access_type                           = "PUBLIC"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = ["*"]
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "profile", "roles", "groups", "email"]
          optional_scopes                       = ["acr", "address", "phone", "offline_access", "organization", "microprofile-jwt", "basic"]
        }

        pomerium = {
          client_id                             = "pomerium"
          name                                  = "pomerium"
          description                           = ""
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["https://pomerium.local.z3cyber.tech/oauth2/callback", "https://192.168.0.7:32443/oauth2/callback"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = ["*"]
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "sample", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        traefik_dmz = {
          client_id                             = "traefik-dmz"
          name                                  = "traefik-dmz"
          description                           = "Traefik DMZ OIDC Client"
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = []
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "sample", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        vikunja = {
          client_id                             = "vikunja-client"
          name                                  = "Vikunja"
          description                           = ""
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = "https://vikunja.local.z3cyber.tech"
          admin_url                             = "https://vikunja.local.z3cyber.tech"
          base_url                              = ""
          valid_redirect_uris                   = ["/auth/openid/keycloak"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = []
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }

        workflows = {
          client_id                             = "workflows"
          name                                  = "Argo Workflows"
          description                           = "Argo Workflows Client"
          enabled                               = true
          access_type                           = "CONFIDENTIAL"
          standard_flow_enabled                 = true
          implicit_flow_enabled                 = false
          direct_access_grants_enabled          = false
          service_accounts_enabled              = false
          frontchannel_logout_enabled           = true
          full_scope_allowed                    = true
          consent_required                      = false
          root_url                              = ""
          admin_url                             = ""
          base_url                              = ""
          valid_redirect_uris                   = ["*"]
          valid_post_logout_redirect_uris       = []
          web_origins                           = [""]
          client_authenticator_type             = "client-secret"
          use_refresh_tokens                    = false
          use_refresh_tokens_client_credentials = false
          default_scopes                        = ["web-origins", "acr", "profile", "roles", "basic", "email"]
          optional_scopes                       = ["address", "phone", "offline_access", "organization", "microprofile-jwt"]
        }
      }

      client_scopes = {
        sample = {
          name                                = "sample"
          description                         = ""
          consent_screen_text                 = ""
          include_in_token_scope              = true
          include_in_openid_provider_metadata = false
        }
        groups = {
          name                                = "groups"
          description                         = ""
          consent_screen_text                 = ""
          include_in_token_scope              = false
          include_in_openid_provider_metadata = false
        }
      }

      roles = {
        homelab_admin = {
          name = "homelab-admin"
        }
        argocd_admin = {
          name       = "argocd-admin"
          client_key = "argocd"
        }
        argocd_user = {
          name       = "argocd-user"
          client_key = "argocd"
        }
        grafana_admin = {
          name       = "admin"
          client_key = "grafana"
        }
        grafana_editor = {
          name       = "editor"
          client_key = "grafana"
        }
        grafana_admin_named = {
          name       = "grafana-admin"
          client_key = "grafana"
        }
        grafana_viewer = {
          name       = "viewer"
          client_key = "grafana"
        }
        workflows_admin = {
          name       = "workflows-admin"
          client_key = "workflows"
        }
        workflows_default = {
          name       = "workflows-default"
          client_key = "workflows"
        }
        workflows_user = {
          name       = "workflows-user"
          client_key = "workflows"
        }
      }

      groups = {
        argocd_admins    = { name = "argocd-admins" }
        k8s_admins       = { name = "k8s-admins" }
        k8s_learners     = { name = "k8s-learners" }
        k8s_operators    = { name = "k8s-operators" }
        k8s_readonly     = { name = "k8s-readonly" }
        workflows_admins = { name = "workflows-admins" }
      }

      group_roles = {
        argocd_admins = {
          group_key = "argocd_admins"
          role_keys = ["argocd_admin"]
        }
      }

      protocol_mappers = {
        argocd_client_roles = {
          target_type     = "client"
          target_key      = "argocd"
          name            = "Client Role Mapper"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-usermodel-client-role-mapper"
          config = {
            "access.token.claim"                   = "true"
            "claim.name"                           = "groups"
            "id.token.claim"                       = "true"
            "introspection.token.claim"            = "true"
            "jsonType.label"                       = "String"
            "lightweight.claim"                    = "false"
            "multivalued"                          = "true"
            "userinfo.token.claim"                 = "true"
            "usermodel.clientRoleMapping.clientId" = "argocd"
          }
        }
        gateway_realm_roles = {
          target_type     = "client"
          target_key      = "gateway"
          name            = "realm_roles"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-usermodel-realm-role-mapper"
          config = {
            "access.token.claim"        = "true"
            "claim.name"                = "realm_roles"
            "id.token.claim"            = "true"
            "introspection.token.claim" = "true"
            "jsonType.label"            = "String"
            "lightweight.claim"         = "false"
            "multivalued"               = "true"
            "userinfo.token.claim"      = "true"
          }
        }
        grafana_roles = {
          target_type     = "client"
          target_key      = "grafana"
          name            = "roles"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-usermodel-client-role-mapper"
          config = {
            "access.token.claim"        = "true"
            "claim.name"                = "roles"
            "id.token.claim"            = "true"
            "introspection.token.claim" = "true"
            "jsonType.label"            = "String"
            "lightweight.claim"         = "false"
            "multivalued"               = "true"
            "userinfo.token.claim"      = "true"
          }
        }
        kubernetes_audience = {
          target_type     = "client"
          target_key      = "kubernetes"
          name            = "kubernetes audience"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-audience-mapper"
          config = {
            "access.token.claim"        = "true"
            "id.token.claim"            = "true"
            "included.client.audience"  = "kubernetes"
            "introspection.token.claim" = "true"
            "lightweight.claim"         = "false"
            "userinfo.token.claim"      = "false"
          }
        }
        workflows_client_roles = {
          target_type     = "client"
          target_key      = "workflows"
          name            = "client roles"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-usermodel-client-role-mapper"
          config = {
            "access.token.claim"                   = "true"
            "claim.name"                           = "groups"
            "id.token.claim"                       = "true"
            "introspection.token.claim"            = "true"
            "jsonType.label"                       = "String"
            "lightweight.claim"                    = "false"
            "multivalued"                          = "true"
            "user.attribute"                       = "foo"
            "userinfo.token.claim"                 = "false"
            "usermodel.clientRoleMapping.clientId" = "workflows"
          }
        }
        sample = {
          target_type     = "client_scope"
          target_key      = "sample"
          name            = "sample"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-usermodel-client-role-mapper"
          config = {
            "access.token.claim"                   = "true"
            "claim.name"                           = "sample"
            "id.token.claim"                       = "true"
            "introspection.token.claim"            = "true"
            "jsonType.label"                       = "String"
            "lightweight.claim"                    = "false"
            "multivalued"                          = "true"
            "userinfo.token.claim"                 = "true"
            "usermodel.clientRoleMapping.clientId" = "harbor"
          }
        }
        groups = {
          target_type     = "client_scope"
          target_key      = "groups"
          name            = "groups"
          protocol        = "openid-connect"
          protocol_mapper = "oidc-group-membership-mapper"
          config = {
            "access.token.claim"        = "true"
            "claim.name"                = "groups"
            "full.path"                 = "false"
            "id.token.claim"            = "true"
            "introspection.token.claim" = "true"
            "lightweight.claim"         = "false"
            "userinfo.token.claim"      = "true"
          }
        }
      }
    }
  }
}
