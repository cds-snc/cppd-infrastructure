resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${local.nameprefix}asp"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = merge(local.common_tags)
}


resource "azurerm_app_service" "app_service" {
  name                = "${local.nameprefix}appservice"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  https_only          = "true"

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.container_registry.login_server}/${var.docker_image}:${var.docker_image_tag}"
    http2_enabled    = true
    always_on        = true
    # virtual_network_name = azurerm_virtual_network.virtual_network.name    
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "DOCKER_ENABLE_CI"                = "true"
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.container_registry.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.container_registry.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.key_vault.vault_uri}secrets/${azurerm_key_vault_secret.docker_password.name}/${azurerm_key_vault_secret.docker_password.version})"
    "SESSION_ADAPTER"                 = "@sailshq/connect-redis"
    "AUTO_MIGRATE_MODE"               = "alter"
    "LOG_LEVEL"                       = "verbose"
    ## Look up from secret
    "DATABASE_URL"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.key_vault.vault_uri}secrets/${azurerm_key_vault_secret.pg_connection_string.name}/${azurerm_key_vault_secret.pg_connection_string.version})"
    "SESSION_ADAPTER_URL"      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.key_vault.vault_uri}secrets/${azurerm_key_vault_secret.redis_connection_string.name}/${azurerm_key_vault_secret.redis_connection_string.version})"
    "FEATURE_REDIS_SSL"        = "true"
    "FEATURE_AZURE_PG_SSL"     = "true"
    "FEATURE_AZ_STORAGE"       = "true"
    "AZURE_STORAGE_ACCOUNT"    = azurerm_storage_account.file_upload.name
    "AZURE_STORAGE_ACCESS_KEY" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.key_vault.vault_uri}secrets/${azurerm_key_vault_secret.storage_access_key.name}/${azurerm_key_vault_secret.storage_access_key.version})"
    "AZURE_STORAGE_CONTAINER"  = azurerm_storage_container.file_upload.name
  }

  tags = merge(local.common_tags)
}

output "possible_ips" {
  value       = azurerm_app_service.app_service.possible_outbound_ip_addresses
  description = "List of potential IP Addresses this service could have, used for feeding into firewall rules"
}