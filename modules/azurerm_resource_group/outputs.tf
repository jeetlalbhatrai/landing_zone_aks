output "rg_names" {
  value = { for k, v in azurerm_resource_group.aks_rg : k => v.name }
}