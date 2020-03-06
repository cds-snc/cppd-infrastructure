resource "azurerm_key_vault" "key_vault" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  tenant_id           = var.tenant_id
  name                = "${local.nameprefix}kv"
  sku_name            = "standard"

  tags = merge(local.common_tags)

}

data "azurerm_client_config" "current" {

}

# Since the terraform service principle will be modifying the key value it should have all the access
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
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "pg_admin_pass" {
  name         = "psqladmin"
  value        = random_password.postgres_admin.result
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = merge(local.common_tags)
}
resource "azurerm_key_vault_secret" "pg_connection_string" {
  name         = "${lower(local.nameprefix)}postgresconnection"
  value        = "postgres://${local.pgadmin_account}@${azurerm_postgresql_database.postgres.name}:${random_password.postgres_admin.result}@${azurerm_postgresql_server.postgres.fqdn}:5432/${azurerm_postgresql_database.postgres.name}"
  key_vault_id = azurerm_key_vault.key_vault.id

  tags = merge(local.common_tags)
}

data "azurerm_key_vault" "central-key-vault" {
  name                = "central-key-vault"
  resource_group_name = "CPPD-Fake-Central-Services"
}

data "azurerm_key_vault_secret" "plsql-admin-pass" {
  name         = "psqladmin"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id
}

data "azurerm_key_vault_secret" "postgres_connection_string" {
  name         = "${lower(local.nameprefix)}postgresconnection"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id
}

data "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "${lower(local.nameprefix)}redisconnection"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id
}
