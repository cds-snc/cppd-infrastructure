resource "azurerm_key_vault" "key_vault" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  tenant_id = var.tenant_id
  name = "${local.nameprefix}kv"
  sku_name = "standard"

  tags = merge(local.common_tags)

  access_policy { 
    object_id = azurerm_app_service.app_service.identity.0.principal_id
    tenant_id = azurerm_app_service.app_service.identity.0.tenant_id
    secret_permissions = [ 
      "get",
      "list",
    ]
  }
}

resource "random_password" "postgres_admin" {
  length = 16
  special = true
  override_special = "_%@"
  keepers { 
    
  }
}

resource "azurerm_key_vault_secret" "pg_admin_pass" {
  name         = "psqladmin"
  value        = random_password.postgres_admin.result 
  key_vault_id = azurerm_key_vault.key_vault.id
  tags = merge(local.common_tags)
}
resource "azurerm_key_vault_secret" "pg_connection_string" {
  name         = "${lower(local.nameprefix)}postgresconnection"
  value        = "postgres://${azurerm_postgresql_database.postgres.administrator_login}@${azurerm_postgresql_database.postgres.name}:${azurerm_postgresql_database.postgres.administrator_login_password}@${azurerm_postgresql_server.postgres.fqdn}:5432/${azurerm_postgresql_database.postgres.name}"
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
