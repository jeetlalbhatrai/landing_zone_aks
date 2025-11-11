output "server_ids" {
  value = { for k, v in azurerm_mssql_server.mssql_server : k => v.id }
}

output "database_ids" {
  value = { for k, v in azurerm_mssql_database.db : k => v.id }
}
