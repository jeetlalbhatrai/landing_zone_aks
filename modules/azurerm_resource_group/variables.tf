# modules/resource_group/variables.tf
variable "rgs" {
  type = map(object({
    location = string
    tags     = optional(map(string))
  }))
}
