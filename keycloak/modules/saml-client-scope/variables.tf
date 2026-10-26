variable "realm_id" {
  type = string
}

variable "scope" {
  type = object({
    name                = string
    description         = optional(string)
    consent_screen_text = optional(string)
    gui_order           = optional(number)
  })
}
