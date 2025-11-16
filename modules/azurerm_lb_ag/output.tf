output "appgw_ids" {
  value = {
    for k, v in azurerm_application_gateway.aks_appgw : k => v.id
  }
}
