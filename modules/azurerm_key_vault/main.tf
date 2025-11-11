resource "azurerm_key_vault" "aks_key_vaults" {
  for_each = var.key_vaults

  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  sku_name                    = each.value.sku_name != null ? each.value.sku_name : "standard"
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = each.value.purge_protection_enabled != null ? each.value.purge_protection_enabled : false
  soft_delete_retention_days  = each.value.soft_delete_retention_days != null ? each.value.soft_delete_retention_days : 7
  rbac_authorization_enabled = each.value.enable_rbac_authorization != null ? each.value.enable_rbac_authorization : true

  # Optional network ACLs
  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      bypass                     = lookup(network_acls.value, "bypass", "AzureServices")
      default_action              = lookup(network_acls.value, "default_action", "Allow")
      ip_rules                    = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids  = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  tags = merge(
    var.default_tags,
    each.value.tags != null ? each.value.tags : {}
  )
}