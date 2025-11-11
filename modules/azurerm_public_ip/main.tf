resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ips

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = lookup(each.value, "allocation_method", "Static")
  sku                 = lookup(each.value, "sku", "Standard")

  zones = lookup(each.value, "zones", null)

  tags = merge(
    {
      environment = "dev"
    },
    lookup(each.value, "tags", {})
  )
}
