# modules/acr/variables.tf
variable "acrs" {
  type = map(object({
    resource_group = string
    location       = string
    sku            = optional(string)
    admin_enabled  = optional(bool)
    tags           = optional(map(string))
  }))
}
