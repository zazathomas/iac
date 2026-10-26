resource "keycloak_generic_protocol_mapper" "this" {
  realm_id        = var.realm_id
  client_id       = var.client_id
  client_scope_id = var.client_scope_id
  name            = var.mapper.name
  protocol        = var.mapper.protocol
  protocol_mapper = var.mapper.protocol_mapper
  config          = var.mapper.config
}
