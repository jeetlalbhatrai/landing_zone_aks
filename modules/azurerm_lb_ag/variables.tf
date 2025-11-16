variable "appgw_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku = object({
      name = string
      tier = string
      capacity = number
    })

    frontend_ip_config = object({
      subnet_id         = optional(string)
      public_ip_id      = optional(string)
    })

    backend_pools = map(object({
      name  = string
      ips   = list(string)
    }))

    http_settings = map(object({
      name                  = string
      port                  = number
      protocol              = string
      cookie_based_affinity = optional(string, "Disabled")
      timeout               = optional(number, 30)
    }))

    listeners = map(object({
      name                           = string
      frontend_port                  = number
      protocol                       = string
      host_name                      = optional(string)
      require_sni                    = optional(bool, false)
    }))

    routing_rules = map(object({
      name               = string
      listener_key       = string
      backend_pool_key   = string
      backend_setting_key = string
    }))
  }))
}
