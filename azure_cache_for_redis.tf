# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "session_store" {
  name                = "EsDC${var.name}rediscache"
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

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redisconnection"
  value        = "redis://${azurerm_redis_cache.session_store.name}:6380,password=${azurerm_redis_cache.session_store.primary_access_key},ssl=True,abortConnect=False"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id

  tags = merge(local.common_tags)
}