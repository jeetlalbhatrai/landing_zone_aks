variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "key_vaults" {
  description = "Map of Key Vault configurations"
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    sku_name                    = optional(string)
    purge_protection_enabled    = optional(bool)
    soft_delete_retention_days  = optional(number)
    enable_rbac_authorization   = optional(bool)
    tags                        = optional(map(string))

    network_acls = optional(object({
      bypass                    = optional(string)
      default_action             = optional(string)
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
  }))
}
