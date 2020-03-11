resource "azurerm_key_vault" "key_vault" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  name                = "${local.nameprefix}kv"
  sku_name            = "standard"

  tags = merge(local.common_tags)

}

data "azurerm_client_config" "current" {

}

resource "azurerm_key_vault_access_policy" "tf_identity" {
  key_vault_id = azurerm_key_vault.key_vault.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "recover",
    "restore",
    "set"
  ]

}
resource "azurerm_key_vault_access_policy" "ap_identity" {

  key_vault_id = azurerm_key_vault.key_vault.id
  object_id    = azurerm_app_service.app_service.identity.0.principal_id
  tenant_id    = azurerm_app_service.app_service.identity.0.tenant_id
  secret_permissions = [
    "get",
    "list",
  ]
}

resource "random_password" "postgres_admin" {
  length  = 16
  special = true
  override_special = "@_!+"
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_key_vault_secret" "pg_admin_pass" {
  name         = "psqladmin"
  value        = random_password.postgres_admin.result
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
  depends_on   = [azurerm_key_vault_access_policy.tf_identity, random_password.postgres_admin]
}

resource "random_password" "postgres_user" {
  length  = 16
  special = true 
  override_special = "@_!+"
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_key_vault_secret" "pg_admin_user" {
  name         = "psqluser"
  value        = random_password.postgres_user.result
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
  depends_on   = [azurerm_key_vault_access_policy.tf_identity, random_password.postgres_user]
}


resource "azurerm_key_vault_secret" "pg_connection_string" {
  name         = "postgresconnection"
  value        = "postgres://${local.pgadmin_account}@${azurerm_postgresql_server.postgres.name}:${random_password.postgres_admin.result}@${azurerm_postgresql_server.postgres.fqdn}:5432/${azurerm_postgresql_database.postgres.name}"
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
  depends_on   = [azurerm_key_vault_access_policy.tf_identity]
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redisconnection"
  value        = "redis://:${azurerm_redis_cache.session_store.primary_access_key}@${azurerm_redis_cache.session_store.hostname}:${azurerm_redis_cache.session_store.ssl_port}"
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
  depends_on   = [azurerm_key_vault_access_policy.tf_identity]
}

resource "azurerm_key_vault_secret" "docker_password" {
  name         = "dockerpword"
  value        = var.container_registry_password
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
  depends_on   = [azurerm_key_vault_access_policy.tf_identity]
}

resource "azurerm_key_vault_secret" "storage_access_key" {
  name         = "storageAccessKey"
  value        = azurerm_storage_account.file_upload.primary_access_key
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
  depends_on   = [azurerm_key_vault_access_policy.tf_identity]
}
