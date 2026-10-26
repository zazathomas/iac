variable "realm_id" {
  type = string
}

variable "client" {
  type = object({
    client_id           = string
    name                = optional(string)
    description         = optional(string)
    enabled             = optional(bool, true)
    full_scope_allowed  = optional(bool, false)
    consent_required    = optional(bool, false)
    root_url            = optional(string)
    base_url            = optional(string)
    valid_redirect_uris = optional(list(string), [])
  })
}
