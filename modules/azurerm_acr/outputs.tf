output "acr_ids" {
  value = { for k, v in azurerm_container_registry.aks_acr : k => v.id }
}
