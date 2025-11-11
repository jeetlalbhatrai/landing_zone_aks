# modules/resource_group/main.tf
resource "azurerm_resource_group" "aks_rg" {
  for_each = var.rgs
  name     = each.key
  location = each.value.location
  tags     = each.value.tags != null ? each.value.tags : {}
}
