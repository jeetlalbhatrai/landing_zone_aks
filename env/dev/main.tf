module "resource_groups" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "virtual_networks" {
  depends_on = [module.resource_groups]
  source = "../../modules/azurerm_virtual_network"
  vnet_map = var.vnet_map
}

module "acr" {
  depends_on = [module.resource_groups, module.virtual_networks]
  source = "../../modules/azurerm_acr"
  acrs   = var.acrs
}

module "aks" {
  depends_on = [module.resource_groups, module.virtual_networks]
  source       = "../../modules/azurerm_aks"
  aks_clusters = var.aks_clusters
}


# data "azurerm_client_config" "current" {}


# module "key_vaults" {
#   depends_on = [module.resource_groups, module.virtual_networks]
#   source = "../../modules/azurerm_key_vault"

#   tenant_id     = data.azurerm_client_config.current.tenant_id
#   default_tags  = var.default_tags
#   key_vaults    = var.key_vaults
# }


# module "mssql" {
#   depends_on = [module.resource_groups, module.virtual_networks, module.key_vaults]
#   source        = "../../modules/azurerm_mssql"
#   mssql_config  = var.mssql_config
#   default_tags  = var.default_tags
# }

# module "virtual_machines" {
#   depends_on = [module.resource_groups, module.virtual_networks]
#   source = "../../modules/azurerm_vm"
#   vms    = var.vms
#   common_tags = var.common_tags
# }


# module "public_ips" {
#   source = "../../modules/azurerm_public_ip"

#   public_ips = var.public_ips
# }


# module "bastion" {
#   source = "../../modules/azurerm_bastion_host"
#   depends_on = [module.resource_groups, module.virtual_networks]
#   bastions = var.bastions
# }

# module "appgw" {
#   source = "../../modules/azurerm_lb_ag"

#   appgw_map = var.appgw_map
# }




