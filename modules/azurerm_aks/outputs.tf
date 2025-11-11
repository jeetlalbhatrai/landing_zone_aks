output "aks_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.aks_cluster : k => v.id }
}

output "aks_principal_ids" {
  description = "Map of AKS cluster names to their principal IDs"
  value = {
    for k, v in azurerm_kubernetes_cluster.aks_cluster :
    k => v.identity[0].principal_id
  }
}
