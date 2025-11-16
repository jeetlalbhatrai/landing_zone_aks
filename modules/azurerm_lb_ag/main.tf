resource "azurerm_application_gateway" "aks_appgw" {
  for_each = var.appgw_map

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku {
    name     = each.value.sku.name
    tier     = each.value.sku.tier
    capacity = each.value.sku.capacity
  }

  gateway_ip_configuration {
    name      = "${each.value.name}-gw-ip"
    subnet_id = each.value.frontend_ip_config.subnet_id
  }

  # FRONTEND PUBLIC IP OR PRIVATE LB (TERNARY)
  frontend_ip_configuration {
    name = "${each.value.name}-fe-ip"

    public_ip_address_id = (
      each.value.frontend_ip_config.public_ip_id != null
      ? each.value.frontend_ip_config.public_ip_id
      : null
    )

    private_ip_address_allocation = (
      each.value.frontend_ip_config.public_ip_id == null
      ? "Dynamic"
      : null
    )
  }

  frontend_port {
    for_each = each.value.listeners
    name     = "${each.key}-${each.value.name}-fp"
    port     = each.value.frontend_port
  }

  # BACKEND POOLS - dynamic block
  dynamic "backend_address_pool" {
    for_each = each.value.backend_pools
    content {
      name  = backend_address_pool.value.name
      backend_addresses = [
        for ip in backend_address_pool.value.ips :
        { ip_address = ip }
      ]
    }
  }

  # HTTP SETTINGS - dynamic
  dynamic "backend_http_settings" {
    for_each = each.value.http_settings
    content {
      name                  = backend_http_settings.value.name
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      request_timeout       = backend_http_settings.value.timeout
    }
  }

  # LISTENERS
  dynamic "http_listener" {
    for_each = each.value.listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = "${each.value.name}-fe-ip"
      frontend_port_name             = "${each.key}-${http_listener.value.name}-fp"
      protocol                       = http_listener.value.protocol
      host_name                      = lookup(http_listener.value, "host_name", null)
      require_sni                    = lookup(http_listener.value, "require_sni", false)
    }
  }

  # ROUTING RULES
  dynamic "request_routing_rule" {
    for_each = each.value.routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = "Basic"
      http_listener_name         = each.value.listeners[request_routing_rule.value.listener_key].name
      backend_address_pool_name  = each.value.backend_pools[request_routing_rule.value.backend_pool_key].name
      backend_http_settings_name = each.value.http_settings[request_routing_rule.value.backend_setting_key].name
    }
  }
}
