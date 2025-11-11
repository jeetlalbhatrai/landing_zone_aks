resource "azurerm_virtual_network" "aks_vnet" {
  for_each = var.vnet_map

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers != null ? each.value.dns_servers : null
  tags                = each.value.tags != null ? each.value.tags : {}

  # --- Create subnets dynamically ---
  dynamic "subnet" {
    for_each = each.value.subnets != null ? each.value.subnets : {}

    content {
      name                                           = subnet.key
      address_prefixes                               = subnet.value.address_prefixes
      service_endpoints                              = subnet.value.service_endpoints != null ? subnet.value.service_endpoints : null
      # private_endpoint_network_policies_enabled      = subnet.value.private_endpoint_network_policies != null ? (subnet.value.private_endpoint_network_policies == "Enabled" ? true : false) : null
      private_link_service_network_policies_enabled  = subnet.value.private_link_service_network_policies != null ? (subnet.value.private_link_service_network_policies == "Enabled" ? true : false) : null
      # network_security_group_id                      = subnet.value.nsg_id != null ? subnet.value.nsg_id : null
    }
  }
}
