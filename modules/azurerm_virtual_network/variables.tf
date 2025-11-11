variable "vnet_map" {
  description = "Map of VNets and their subnet definitions."
  type = map(object({
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    tags                = optional(map(string))
    subnets = optional(map(object({
      address_prefixes       = list(string)
      service_endpoints      = optional(list(string))
      # private_endpoint_network_policies = optional(string)
      private_link_service_network_policies = optional(string)
      # nsg_id                 = optional(string)
    })))
  }))
}
