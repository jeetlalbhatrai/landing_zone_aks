variable "public_ips" {
  description = "Map of Public IPs to create"
  type = map(object({
    location            = string
    resource_group_name = string
    allocation_method   = optional(string, "Static") # Static or Dynamic
    sku                 = optional(string, "Standard")
    zones               = optional(list(string))
    tags                = optional(map(string))
  }))
}
