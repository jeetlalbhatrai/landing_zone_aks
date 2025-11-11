resource "azurerm_mssql_server" "mssql_server" {
  for_each = var.mssql_config

  name                         = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  version                       = lookup(each.value, "version", "12.0")
  administrator_login           = lookup(each.value, "admin_login", null)
  administrator_login_password  = lookup(each.value, "admin_password", null)
  minimum_tls_version           = lookup(each.value, "minimum_tls_version", "1.2")
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  tags                          = var.default_tags
}

# Optional AD Administrator
resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
  for_each = { for k, v in var.mssql_config : k => v if try(v.audit_storage_account_id, null) != null }

  server_id                = azurerm_mssql_server.mssql_server[each.key].id
  storage_endpoint         = each.value.audit_storage_account_id
  retention_in_days        = lookup(each.value, "audit_retention_days", 30)
  log_monitoring_enabled   = lookup(each.value, "log_monitoring_enabled", true)
}

# Optional Firewall Rules
# resource "azurerm_mssql_firewall_rule" "fw" {
#   for_each = { for k, v in var.mssql_config : k => v if try(v.firewall_rules, null) != null }

#   # Create dynamic block for multiple firewall rules
#   dynamic "rule" {
#     for_each = each.value.firewall_rules
#     content {
#       name             = rule.value.name
#       server_id        = azurerm_mssql_server.mssql_server[each.key].id
#       start_ip_address = rule.value.start_ip
#       end_ip_address   = rule.value.end_ip
#     }
#   }
# }

# Databases
resource "azurerm_mssql_database" "db" {
  for_each = { for db_key, db_val in local.all_dbs : db_key => db_val }

  name           = each.value.name
  server_id      = azurerm_mssql_server.mssql_server[each.value.server_key].id
  sku_name       = lookup(each.value, "sku_name", "S0")
  max_size_gb    = lookup(each.value, "max_size_gb", 5)
  zone_redundant = lookup(each.value, "zone_redundant", false)
  tags           = var.default_tags
}

locals {
  all_dbs = flatten([
    for server_key, server_val in var.mssql_config : [
      for db in lookup(server_val, "databases", []) : merge(db, { server_key = server_key })
    ]
  ])
}
