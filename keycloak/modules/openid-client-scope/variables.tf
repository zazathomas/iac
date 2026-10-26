variable "realm_id" {
  type = string
}

variable "scope" {
  type = object({
    name                                = string
    description                         = optional(string)
    consent_screen_text                 = optional(string)
    include_in_token_scope              = optional(bool, true)
    include_in_openid_provider_metadata = optional(bool, true)
    gui_order                           = optional(number)
  })
}
