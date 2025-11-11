# ==============================
#   Network Interface
# ==============================
resource "azurerm_network_interface" "vm_nic" {
  for_each            = var.vms
  name                = "${each.key}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.aks_subnet[each.key].id
    private_ip_address_allocation = each.value.private_ip_allocation != null ? each.value.private_ip_allocation : "Dynamic"
    # public_ip_address_id          = each.value.public_ip_id != null ? each.value.public_ip_id : null
    public_ip_address_id          = data.azurerm_public_ip.public_ip[each.key].id != null ? data.azurerm_public_ip.public_ip[each.key].id : null
  }

  tags = merge(var.common_tags, each.value.tags != null ? each.value.tags : {})
}

# ==============================
#   Virtual Machine
# ==============================
resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vms
  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

source_image_reference {
    publisher = try(each.value.source_image_reference.publisher, "Canonical")
    offer     = try(each.value.source_image_reference.offer, "0001-com-ubuntu-server-jammy")
    sku       = try(each.value.source_image_reference.sku, "22_04-lts")
    version   = try(each.value.source_image_reference.version, "latest")
  }

  os_disk {
    caching              = each.value.os_disk.caching != null ? each.value.os_disk.caching : "ReadWrite"
    storage_account_type = each.value.os_disk.storage_account_type != null ? each.value.os_disk.storage_account_type : "Standard_LRS"
  }

  # Optional Identity block
  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = lookup(identity.value, "type", "SystemAssigned")
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  custom_data = each.value.custom_data != null ? base64encode(each.value.custom_data) : null

  tags = merge(var.common_tags, each.value.tags != null ? each.value.tags : {})
}
