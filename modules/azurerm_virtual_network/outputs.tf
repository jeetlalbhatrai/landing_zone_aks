output "vnet_ids" {
  description = "Map of virtual network IDs"
  value = { for k, v in azurerm_virtual_network.aks_vnet : k => v.id }
}

output "subnet_ids" {
  description = "Map of subnets with their IDs"
  value = {
    for vnet_name, aks_vnet in azurerm_virtual_network.aks_vnet :
    vnet_name => {
      for s in aks_vnet.subnet : s.name => s.id
    }
  }
}
