output "public_ip_ids" {
  description = "Map of Public IP IDs"
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.id }
}

output "public_ip_addresses" {
  description = "Map of Public IP addresses"
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.ip_address }
}
