variable "realm_id" {
  type = string
}

variable "client_id" {
  type    = string
  default = null
}

variable "client_scope_id" {
  type    = string
  default = null
}

variable "mapper" {
  type = object({
    name            = string
    protocol        = string
    protocol_mapper = string
    config          = map(string)
  })
}
