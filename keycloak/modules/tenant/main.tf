locals {
  openid_clients = {
    for key, client in var.tenant.clients : key => client
    if client.protocol == "openid-connect"
  }

  saml_clients = {
    for key, client in var.tenant.clients : key => client
    if client.protocol == "saml"
  }

  openid_scopes = {
    for key, scope in var.tenant.client_scopes : key => scope
    if scope.protocol == "openid-connect"
  }

  saml_scopes = {
    for key, scope in var.tenant.client_scopes : key => scope
    if scope.protocol == "saml"
  }

  client_scope_names = merge(
    { for key, scope in module.openid_scope : key => scope.scope_name },
    { for key, scope in module.saml_scope : key => scope.scope_name },
  )

  client_resource_ids = merge(
    { for key, client in module.openid_client : key => client.client_id },
    { for key, client in module.saml_client : key => client.client_id },
  )

  root_groups = {
    for key, group in var.tenant.groups : key => group
    if try(group.parent_key, null) == null
  }

  child_groups = {
    for key, group in var.tenant.groups : key => group
    if try(group.parent_key, null) != null
  }

  group_resource_ids = merge(
    { for key, group in module.group : key => group.group_id },
    { for key, group in module.child_group : key => group.group_id },
  )
}

module "realm" {
  source            = "../realm"
  realm             = var.tenant.realm
  security_baseline = var.tenant.realm.security_baseline
}

module "openid_client" {
  for_each = local.openid_clients
  source   = "../openid-client"

  realm_id = module.realm.realm_id
  client = {
    client_id                             = each.value.client_id
    name                                  = each.value.name
    description                           = each.value.description
    enabled                               = each.value.enabled
    access_type                           = each.value.access_type
    standard_flow_enabled                 = each.value.standard_flow_enabled
    implicit_flow_enabled                 = each.value.implicit_flow_enabled
    direct_access_grants_enabled          = each.value.direct_access_grants_enabled
    service_accounts_enabled              = each.value.service_accounts_enabled
    frontchannel_logout_enabled           = each.value.frontchannel_logout_enabled
    full_scope_allowed                    = each.value.full_scope_allowed
    consent_required                      = each.value.consent_required
    root_url                              = each.value.root_url
    admin_url                             = each.value.admin_url
    base_url                              = each.value.base_url
    valid_redirect_uris                   = each.value.valid_redirect_uris
    valid_post_logout_redirect_uris       = each.value.valid_post_logout_redirect_uris
    web_origins                           = each.value.web_origins
    client_authenticator_type             = each.value.client_authenticator_type
    pkce_code_challenge_method            = each.value.pkce_code_challenge_method
    use_refresh_tokens                    = each.value.use_refresh_tokens
    use_refresh_tokens_client_credentials = each.value.use_refresh_tokens_client_credentials
    authorization                         = each.value.authorization
  }
}

module "saml_client" {
  for_each = local.saml_clients
  source   = "../saml-client"

  realm_id = module.realm.realm_id
  client = {
    client_id           = each.value.client_id
    name                = each.value.name
    description         = each.value.description
    enabled             = each.value.enabled
    full_scope_allowed  = each.value.full_scope_allowed
    consent_required    = each.value.consent_required
    root_url            = each.value.root_url
    base_url            = each.value.base_url
    valid_redirect_uris = each.value.valid_redirect_uris
  }
}

module "openid_scope" {
  for_each = local.openid_scopes
  source   = "../openid-client-scope"

  realm_id = module.realm.realm_id
  scope = {
    name                                = each.value.name
    description                         = each.value.description
    consent_screen_text                 = each.value.consent_screen_text
    include_in_token_scope              = each.value.include_in_token_scope
    include_in_openid_provider_metadata = each.value.include_in_openid_provider_metadata
    gui_order                           = each.value.gui_order
  }
}

module "saml_scope" {
  for_each = local.saml_scopes
  source   = "../saml-client-scope"

  realm_id = module.realm.realm_id
  scope = {
    name                = each.value.name
    description         = each.value.description
    consent_screen_text = each.value.consent_screen_text
    gui_order           = each.value.gui_order
  }
}

module "openid_default_scopes" {
  for_each = {
    for key, client in local.openid_clients : key => client
    if length(client.default_scopes) > 0
  }
  source = "../openid-client-default-scopes"

  realm_id       = module.realm.realm_id
  client_id      = module.openid_client[each.key].client_id
  default_scopes = [for scope_key in each.value.default_scopes : try(local.client_scope_names[scope_key], scope_key)]
}

module "openid_optional_scopes" {
  for_each = {
    for key, client in local.openid_clients : key => client
    if length(client.optional_scopes) > 0
  }
  source = "../openid-client-optional-scopes"

  realm_id        = module.realm.realm_id
  client_id       = module.openid_client[each.key].client_id
  optional_scopes = [for scope_key in each.value.optional_scopes : try(local.client_scope_names[scope_key], scope_key)]
}

module "saml_default_scopes" {
  for_each = {
    for key, client in local.saml_clients : key => client
    if length(client.default_scopes) > 0
  }
  source = "../saml-client-default-scopes"

  realm_id       = module.realm.realm_id
  client_id      = module.saml_client[each.key].client_id
  default_scopes = [for scope_key in each.value.default_scopes : try(local.client_scope_names[scope_key], scope_key)]
}

module "role" {
  for_each = var.tenant.roles
  source   = "../role"

  realm_id = module.realm.realm_id
  role = {
    name        = each.value.name
    client_id   = try(local.client_resource_ids[each.value.client_key], null)
    description = each.value.description
    attributes  = each.value.attributes
  }
}

module "group" {
  for_each = local.root_groups
  source   = "../group"

  realm_id = module.realm.realm_id
  group = {
    name       = each.value.name
    attributes = each.value.attributes
  }
}

module "child_group" {
  for_each = local.child_groups
  source   = "../group"

  realm_id = module.realm.realm_id
  group = {
    name       = each.value.name
    parent_id  = module.group[each.value.parent_key].group_id
    attributes = each.value.attributes
  }
}

module "group_roles" {
  for_each = var.tenant.group_roles
  source   = "../group-roles"

  realm_id   = module.realm.realm_id
  group_id   = local.group_resource_ids[each.value.group_key]
  role_ids   = [for role_key in each.value.role_keys : module.role[role_key].role_id]
  exhaustive = each.value.exhaustive
}

module "protocol_mapper" {
  for_each = var.tenant.protocol_mappers
  source   = "../protocol-mapper"

  realm_id  = module.realm.realm_id
  client_id = each.value.target_type == "client" ? try(local.client_resource_ids[each.value.target_key], null) : null
  client_scope_id = each.value.target_type == "client_scope" ? try(
    module.openid_scope[each.value.target_key].scope_id,
    module.saml_scope[each.value.target_key].scope_id,
    null,
  ) : null
  mapper = {
    name            = each.value.name
    protocol        = each.value.protocol
    protocol_mapper = each.value.protocol_mapper
    config          = each.value.config
  }
}
