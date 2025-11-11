# modules/acr/main.tf
resource "azurerm_container_registry" "aks_acr" {
  for_each = var.acrs
  name                = each.key
  resource_group_name = each.value.resource_group
  location            = each.value.location
  sku                 = each.value.sku != null ? each.value.sku : "Basic"
  admin_enabled       = each.value.admin_enabled != null ? each.value.admin_enabled : false
  tags                = each.value.tags != null ? each.value.tags : {}
}

