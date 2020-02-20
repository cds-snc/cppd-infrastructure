resource "azurerm_redis_firewall_rule" "redis_firewall_rule" {
  count               = length(local.appserviceips)
  name                = "appserviceip${count.index}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  redis_cache_name    = data.azurerm_redis_cache.session_store.name
  start_ip            = local.appserviceips[count.index]
  end_ip              = local.appserviceips[count.index]
}