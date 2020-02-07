resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "EsDC${var.name}asp"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "B1"
  }

  tags = merge ( local.common_tags)
}

resource "azurerm_app_service" "app_service" {
  name                = "EsDC${var.name}appservice"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.container_registry.login_server}/${var.docker_image}:${var.docker_image_tag}"
    http2_enabled    = true
    always_on        = true
  }

  app_settings = {
    "DOCKER_ENABLE_CI"                = "true"
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.container_registry.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.container_registry.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.container_registry.admin_password
  }

  connection_string {
    name  = "DATABASE_URL"
    type  = "PostgreSQL"
    value = data.azurerm_key_vault_secret.postgres-connection-string.value
  }

  connection_string {
    name  = "SESSION_ADAPTER_URL"
    type  = "RedisCache"
    value = data.azurerm_key_vault_secret.redis-connection-string.value
  }

  tags = merge ( local.common_tags )
}
