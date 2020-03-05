
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "session_store" {
  name                = "${local.nameprefix}cache"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  capacity            = 2
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {}

  tags = merge(local.common_tags)
}