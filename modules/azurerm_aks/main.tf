# modules/aks/main.tf
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  for_each            = var.aks_clusters
  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group
  dns_prefix = each.value.dns_prefix
  kubernetes_version  = each.value.k8s_version
  tags                = each.value.tags != null ? each.value.tags : {}

  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.count
    vm_size    = each.value.default_node_pool.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = each.value.network_plugin
    network_policy     = each.value.network_policy
    dns_service_ip     = each.value.dns_service_ip
    service_cidr       = each.value.service_cidr
  }

#   addon_profile {
#   oms_agent {
#     enabled = each.value.enable_monitoring != null ? each.value.enable_monitoring : false
#     log_analytics_workspace_id = each.value.log_analytics_workspace_id != null ? each.value.log_analytics_workspace_id : ""
#   }
# }
}

