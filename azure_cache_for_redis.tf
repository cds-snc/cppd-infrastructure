
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "session_store" {
  name                = "${local.nameprefix}cache"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {}

  tags = merge(local.common_tags)
}

resource "azurerm_redis_firewall_rule" "redis_firewall_rule" {
  for_each            = toset(split(",", azurerm_app_service.app_service.possible_outbound_ip_addresses))
  name                = "appserviceip"
  resource_group_name = azurerm_resource_group.resource_group.name
  redis_cache_name    = azurerm_redis_cache.session_store.name
  start_ip_address    = each.value
  end_ip_address      = each.value
}