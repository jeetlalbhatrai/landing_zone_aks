output "key_vault_ids" {
  description = "Map of Key Vault IDs"
  value       = { for k, v in azurerm_key_vault.aks_key_vaults : k => v.id }
}

output "key_vault_names" {
  description = "Map of Key Vault names"
  value       = { for k, v in azurerm_key_vault.aks_key_vaults : k => v.name }
}
