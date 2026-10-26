variable "realm_id" {
  type = string
}

variable "group_id" {
  type = string
}

variable "role_ids" {
  description = "Provider role resource IDs assigned to the group."
  type        = list(string)
}

variable "exhaustive" {
  description = "Whether this module owns the complete role set for the group."
  type        = bool
  default     = true
}
