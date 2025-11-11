output "vm_ids" {
  description = "IDs of created VMs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.id }
}

output "nic_ids" {
  description = "IDs of created NICs"
  value       = { for k, v in azurerm_network_interface.vm_nic : k => v.id }
}
