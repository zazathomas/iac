variable "realm_id" {
  type = string
}

variable "role" {
  type = object({
    name        = string
    client_id   = optional(string)
    description = optional(string)
    attributes  = optional(map(string), {})
  })
}
