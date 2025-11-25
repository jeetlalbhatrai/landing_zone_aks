# modules/resource_group/variables.tf
variable "rgs" {
  type = map(object({
    location = string
    tags     = optional(map(string))
  }))
}

# modules/vnet/variables.tf
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

# modules/aks/variables.tf
variable "aks_clusters" {
  type = map(object({
    location                  = string
    resource_group            = string
    dns_prefix                = string
    k8s_version               = string
    network_plugin            = string
    network_policy            = string
    dns_service_ip            = optional(string)
    service_cidr              = optional(string)
    docker_bridge_cidr        = optional(string)
    default_node_pool = object({
      name     = string
      count    = number
      vm_size  = string
    })
    # enable_monitoring          = optional(bool)
    # log_analytics_workspace_id = optional(string)
    tags                       = optional(map(string))
  }))
}

# variable "tenant_id" {
#   description = "Azure tenant ID"
#   type        = string
# }

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

variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    location             = string
    resource_group_name  = string
    public_ip_id         = optional(string)
    private_ip_allocation = optional(string)
    vm_size              = string
    admin_username       = string
    admin_password           = string
    subnet_name = string
     pip_name                  = string
    vnet_name = string
    vnet_resource_group_name = string
    os_disk = optional(object({
      caching              = optional(string)
      storage_account_type = optional(string)
    }))
    data_disks = optional(list(object({
      lun                = number
      size_gb            = number
      caching            = optional(string)
      storage_account_type = optional(string)
    })))
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

variable "bastions" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_name        = string
    vnet_name          = string
    vnet_resource_group_name = string
    pip_name           = string
    sku                 = optional(string)
  }))
}


