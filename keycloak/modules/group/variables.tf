variable "realm_id" {
  type = string
}

variable "group" {
  type = object({
    name       = string
    parent_id  = optional(string)
    attributes = optional(map(string), {})
  })
}
