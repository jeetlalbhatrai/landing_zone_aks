variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    location                  = string
    resource_group_name       = string
    vnet_resource_group_name  = string
    vnet_name                 = string
    subnet_name               = string
    public_ip_id              = optional(string)
    private_ip_allocation     = optional(string)
    vm_size                   = string
    admin_username            = string
    admin_password           = string
    pip_name                  = string

    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
    }))

    os_disk = optional(object({
      caching              = optional(string)
      storage_account_type = optional(string)
    }))

    identity = optional(object({
      type         = optional(string)
      identity_ids = optional(list(string))
    }))

    custom_data = optional(string)
    tags        = optional(map(string))
  }))
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
