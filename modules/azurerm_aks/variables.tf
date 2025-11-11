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
