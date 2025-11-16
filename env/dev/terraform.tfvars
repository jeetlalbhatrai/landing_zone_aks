rgs = {
  "rg-aks" = { location = "Canada East", tags = { environment="dev" } }
}

vnet_map = {
  vnet-aks = {
    location            = "Canada East"
    resource_group_name = "rg-aks"
    address_space       = ["10.0.0.0/16"]
    dns_servers         = ["8.8.8.8"]
    tags = {
      environment = "dev"
    }
    subnets = {
      "subnet-frontend" = {
        address_prefixes  = ["10.0.1.0/24"]
        # service_endpoints = ["Microsoft.ContainerRegistry"]
      }
      "backend-db" = {
        address_prefixes  = ["10.0.2.0/24"]
      }
      "AzureBastionSubnet" = {
        address_prefixes = ["10.0.3.0/24"]
    }
  }
}
}

acrs = {
  "acrtestaks" = { resource_group="rg-aks", location="Canada East", admin_enabled=true }
}

aks_clusters = {
  "aks-dev" = {
    location                  = "Canada East"
    resource_group            = "rg-aks"
    dns_prefix                = "aksdev"
    k8s_version               = "1.32.7"
    network_plugin            = "azure"
    network_policy            = "azure"
    # dns_service_ip            = "10.0.0.10"
    # service_cidr              = "10.0.0.0/16"
    # docker_bridge_cidr        = "172.17.0.1/16"
    default_node_pool = { name="aksagent", count=2, vm_size="standard_a2_v2" }
    # enable_monitoring         = true
    # log_analytics_workspace_id = "/subscriptions/<id>/resourceGroups/rg-dev/providers/Microsoft.OperationalInsights/workspaces/loganalytics"
    tags                       = { environment="dev" }
  }
}

key_vaults = {
  kv-prod = {
    name                = "aks-keyvault"
    location            = "Canada East"
    resource_group_name = "rg-aks"
    sku_name            = "premium"
    enable_rbac_authorization = true

    network_acls = {
      bypass        = "AzureServices"
      default_action = "Deny"
      ip_rules       = ["10.0.0.0/24"]
    }
  }

  kv-dev = {
    name                = "dev-keyvault"
    location            = "West Europe"
    resource_group_name = "rg-dev"
    purge_protection_enabled = false
  }
}

default_tags = {
  environment = "dev"
  owner       = "jeet"
}

mssql_config = {
  sql1 = {
    name                = "mssql-prod"
    location            = "eastus"
    resource_group_name = "rg-prod"
    admin_login         = "sqladmin"
    admin_password      = "ChangeMe123!"
    version             = "12.0"

    public_network_access_enabled = true
    minimum_tls_version           = "1.2"

    # firewall_rules = [
    #   {
    #     name     = "office"
    #     start_ip = "49.36.22.1"
    #     end_ip   = "49.36.22.1"
    #   },
    #   {
    #     name     = "any"
    #     start_ip = "0.0.0.0"
    #     end_ip   = "255.255.255.255"
    #   }
    # ]

    databases = [
      {
        name        = "appdb1"
        sku_name    = "S0"
        max_size_gb = 10
      },
      {
        name        = "appdb2"
        sku_name    = "S1"
        max_size_gb = 20
      }
    ]
  }
}


common_tags = {
  environment = "dev"
  owner       = "jeet"
}

vms = {
  "frontend-vm" = {
    location                  = "Canada East"
    resource_group_name       = "rg-aks"
    vnet_resource_group_name  = "rg-aks"
    vnet_name                 = "vnet-aks"
    subnet_name               = "subnet-frontend"
    vm_size                   = "Standard_B2s"
    admin_username            = "azureuser"
    admin_password            = "MyP@ssword123!"
    pip_name                  = "frontend-pip"

    os_disk = {
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    identity = {
      type = "SystemAssigned"
    }

    tags = {
      role = "app"
    }
  }
  "backend-vm" = {
    location                  = "Canada East"
    resource_group_name       = "rg-aks"
    vnet_resource_group_name  = "rg-aks"
    vnet_name                 = "vnet-aks"
    subnet_name               = "subnet-backend"
    vm_size                   = "Standard_B2s"
    admin_username            = "azureuser"
    admin_password            = "MyP@ssword123!"
    pip_name                  = "backend-pip"

    os_disk = {
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    identity = {
      type = "SystemAssigned"
    }

    tags = {
      role = "app"
    }
  }
}

public_ips = {
  "frontend-pip" = {
    location            = "Canada East"
    resource_group_name = "rg-aks"
    allocation_method   = "Static"
    sku                 = "Standard"
    tags = {
      role = "frontend-app"
    }
  }

  "backend-pip" = {
    location            = "Canada East"
    resource_group_name = "rg-aks"
    allocation_method   = "Dynamic"
    sku                 = "Standard"
    tags = {
      role = "backend-app"
    }
  }
}

bastions = {
    bastion = {
      name                = "bastion-host"
      location            = "Canada East"
      resource_group_name = "rg-aks"
    vnet_resource_group_name = "rg-aks"
      subnet_name         = "AzureBastionSubnet"
      vnet_name           = "vnet-aks"
      pip_name            = "bastion-pip"
    }
  }

#application gw for dev environment
appgw_map = {
  agw1 = {
    name                = "appgw-prod"
    location            = "eastus"
    resource_group_name = "rg-prod"

    sku = {
      name     = "WAF_v2"
      tier     = "WAF_v2"
      capacity = 2
    }

    frontend_ip_config = {
      public_ip_id = "/subscriptions/xxx/resourceGroups/rg-prod/providers/Microsoft.Network/publicIPAddresses/pip-appgw"
      subnet_id    = null
    }

    backend_pools = {
      api = {
        name = "api-pool"
        ips  = ["10.0.2.4", "10.0.2.5"]
      }
    }

    http_settings = {
      default = {
        name  = "default-settings"
        port  = 80
        protocol = "Http"
      }
    }

    listeners = {
      http = {
        name          = "http-listener"
        frontend_port = 80
        protocol      = "Http"
      }
    }

    routing_rules = {
      rule1 = {
        name                = "rule1"
        listener_key        = "http"
        backend_pool_key    = "api"
        backend_setting_key = "default"
      }
    }
  }
}


