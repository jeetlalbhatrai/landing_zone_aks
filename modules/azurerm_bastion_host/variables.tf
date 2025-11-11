variable "bastions" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    # subnet_id           = string
    # public_ip_id        = string
    subnet_name        = string
    vnet_name          = string
    vnet_resource_group_name = string
    pip_name           = string
    sku                 = optional(string)
  }))
}
