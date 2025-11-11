variable "mssql_config" {
  description = "Map of MSSQL server configurations"
  type = map(object({
    name                         = string
    resource_group_name           = string
    location                      = string
    version                       = optional(string)
    admin_login                   = optional(string)
    admin_password                = optional(string)
    minimum_tls_version           = optional(string)
    public_network_access_enabled = optional(bool)
    audit_storage_account_id      = optional(string)
    audit_retention_days          = optional(number)
    log_monitoring_enabled        = optional(bool)
    firewall_rules = optional(list(object({
      name      = string
      start_ip  = string
      end_ip    = string
    })))
    databases = optional(list(object({
      name           = string
      sku_name       = optional(string)
      max_size_gb    = optional(number)
      zone_redundant = optional(bool)
    })))
  }))
}


variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
