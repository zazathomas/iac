# State migration from the original flat root layout to the tenant stack.
# Remove these blocks after every environment has completed the migration.

moved {
  from = module.homelab_realm
  to   = module.realms.module.tenant["homelab"].module.realm
}

moved {
  from = module.homelab_actual_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["actual"]
}
moved {
  from = module.homelab_argocd_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["argocd"]
}
moved {
  from = module.homelab_gateway_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["gateway"]
}
moved {
  from = module.homelab_grafana_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["grafana"]
}
moved {
  from = module.homelab_harbor_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["harbor"]
}
moved {
  from = module.homelab_karakeep_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["karakeep"]
}
moved {
  from = module.homelab_kubernetes_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["kubernetes"]
}
moved {
  from = module.homelab_pomerium_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["pomerium"]
}
moved {
  from = module.homelab_traefik_dmz_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["traefik_dmz"]
}
moved {
  from = module.homelab_vikunja_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["vikunja"]
}
moved {
  from = module.homelab_workflows_client
  to   = module.realms.module.tenant["homelab"].module.openid_client["workflows"]
}

moved {
  from = module.homelab_role_list_client_scope
  to   = module.realms.module.tenant["homelab"].module.saml_scope["role_list"]
}
moved {
  from = module.homelab_saml_organization_client_scope
  to   = module.realms.module.tenant["homelab"].module.saml_scope["saml_organization"]
}
moved {
  from = module.homelab_authncontextclassref_client_scope
  to   = module.realms.module.tenant["homelab"].module.saml_scope["authn_context"]
}
moved {
  from = module.homelab_organization_client_scope
  to   = module.realms.module.tenant["homelab"].module.openid_scope["organization"]
}
moved {
  from = module.homelab_sample_client_scope
  to   = module.realms.module.tenant["homelab"].module.openid_scope["sample"]
}
moved {
  from = module.homelab_service_account_client_scope
  to   = module.realms.module.tenant["homelab"].module.openid_scope["service_account"]
}
moved {
  from = module.homelab_groups_client_scope
  to   = module.realms.module.tenant["homelab"].module.openid_scope["groups"]
}

moved {
  from = module.homelab_actual_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["actual"]
}
moved {
  from = module.homelab_actual_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["actual"]
}
moved {
  from = module.homelab_argocd_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["argocd"]
}
moved {
  from = module.homelab_argocd_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["argocd"]
}
moved {
  from = module.homelab_gateway_client_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["gateway"]
}
moved {
  from = module.homelab_gateway_client_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["gateway"]
}
moved {
  from = module.homelab_grafana_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["grafana"]
}
moved {
  from = module.homelab_grafana_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["grafana"]
}
moved {
  from = module.homelab_harbor_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["harbor"]
}
moved {
  from = module.homelab_harbor_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["harbor"]
}
moved {
  from = module.homelab_karakeep_client_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["karakeep"]
}
moved {
  from = module.homelab_karakeep_client_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["karakeep"]
}
moved {
  from = module.homelab_kubernetes_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["kubernetes"]
}
moved {
  from = module.homelab_kubernetes_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["kubernetes"]
}
moved {
  from = module.homelab_pomerium_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["pomerium"]
}
moved {
  from = module.homelab_pomerium_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["pomerium"]
}
moved {
  from = module.homelab_traefik_dmz_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["traefik_dmz"]
}
moved {
  from = module.homelab_traefik_dmz_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["traefik_dmz"]
}
moved {
  from = module.homelab_vikunja_client_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["vikunja"]
}
moved {
  from = module.homelab_vikunja_client_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["vikunja"]
}
moved {
  from = module.homelab_workflows_default_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_default_scopes["workflows"]
}
moved {
  from = module.homelab_workflows_optional_scopes
  to   = module.realms.module.tenant["homelab"].module.openid_optional_scopes["workflows"]
}

moved {
  from = module.homelab_realm_homelab_admin_role
  to   = module.realms.module.tenant["homelab"].module.role["homelab_admin"]
}
moved {
  from = module.homelab_argocd_argocd_admin_role
  to   = module.realms.module.tenant["homelab"].module.role["argocd_admin"]
}
moved {
  from = module.homelab_argocd_argocd_user_role
  to   = module.realms.module.tenant["homelab"].module.role["argocd_user"]
}
moved {
  from = module.homelab_grafana_admin_role
  to   = module.realms.module.tenant["homelab"].module.role["grafana_admin"]
}
moved {
  from = module.homelab_grafana_editor_role
  to   = module.realms.module.tenant["homelab"].module.role["grafana_editor"]
}
moved {
  from = module.homelab_grafana_grafana_admin_role
  to   = module.realms.module.tenant["homelab"].module.role["grafana_admin_named"]
}
moved {
  from = module.homelab_grafana_viewer_role
  to   = module.realms.module.tenant["homelab"].module.role["grafana_viewer"]
}
moved {
  from = module.homelab_harbor_harbor_admin_role
  to   = module.realms.module.tenant["homelab"].module.role["harbor_admin"]
}
moved {
  from = module.homelab_harbor_harbor_user_role
  to   = module.realms.module.tenant["homelab"].module.role["harbor_user"]
}
moved {
  from = module.homelab_harbor_uma_protection_role
  to   = module.realms.module.tenant["homelab"].module.role["harbor_uma_protection"]
}
moved {
  from = module.homelab_workflows_workflows_admin_role
  to   = module.realms.module.tenant["homelab"].module.role["workflows_admin"]
}
moved {
  from = module.homelab_workflows_workflows_default_role
  to   = module.realms.module.tenant["homelab"].module.role["workflows_default"]
}
moved {
  from = module.homelab_workflows_workflows_user_role
  to   = module.realms.module.tenant["homelab"].module.role["workflows_user"]
}

moved {
  from = module.homelab_argocd_admins_group
  to   = module.realms.module.tenant["homelab"].module.group["argocd_admins"]
}
moved {
  from = module.homelab_harbor_admins_group
  to   = module.realms.module.tenant["homelab"].module.group["harbor_admins"]
}
moved {
  from = module.homelab_k8s_admins_group
  to   = module.realms.module.tenant["homelab"].module.group["k8s_admins"]
}
moved {
  from = module.homelab_k8s_learners_group
  to   = module.realms.module.tenant["homelab"].module.group["k8s_learners"]
}
moved {
  from = module.homelab_k8s_operators_group
  to   = module.realms.module.tenant["homelab"].module.group["k8s_operators"]
}
moved {
  from = module.homelab_k8s_readonly_group
  to   = module.realms.module.tenant["homelab"].module.group["k8s_readonly"]
}
moved {
  from = module.homelab_workflows_admins_group
  to   = module.realms.module.tenant["homelab"].module.group["workflows_admins"]
}
moved {
  from = module.homelab_argocd_admins_group_roles
  to   = module.realms.module.tenant["homelab"].module.group_roles["argocd_admins"]
}
moved {
  from = module.homelab_harbor_admins_group_roles
  to   = module.realms.module.tenant["homelab"].module.group_roles["harbor_admins"]
}

moved {
  from = module.homelab_argocd_client_role_mapper_client_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["argocd_client_roles"]
}
moved {
  from = module.homelab_gateway_client_realm_roles_client_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["gateway_realm_roles"]
}
moved {
  from = module.homelab_grafana_roles_client_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["grafana_roles"]
}
moved {
  from = module.homelab_kubernetes_kubernetes_audience_client_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["kubernetes_audience"]
}
moved {
  from = module.homelab_workflows_client_roles_client_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["workflows_client_roles"]
}
moved {
  from = module.homelab_role_list_role_list_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["role_list"]
}
moved {
  from = module.homelab_saml_organization_organization_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["saml_organization"]
}
moved {
  from = module.homelab_authncontextclassref_authncontextclassref_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["authn_context"]
}
moved {
  from = module.homelab_organization_organization_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["organization"]
}
moved {
  from = module.homelab_sample_sample_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["sample"]
}
moved {
  from = module.homelab_service_account_client_id_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["service_account_client_id"]
}
moved {
  from = module.homelab_service_account_client_ip_address_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["service_account_client_ip"]
}
moved {
  from = module.homelab_service_account_client_host_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["service_account_client_host"]
}
moved {
  from = module.homelab_groups_groups_scope_mapper
  to   = module.realms.module.tenant["homelab"].module.protocol_mapper["groups"]
}
