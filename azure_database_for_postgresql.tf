
resource "azurerm_postgresql_server" "postgres" {
  name                = "cppd-postgres-server"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku_name = "B_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Disabled"
  }

  administrator_login          = "psqladmin"
  administrator_login_password = data.azurerm_key_vault_secret.plsql-admin-pass.value
  version                      = "11"
  ssl_enforcement              = "Enabled"

  tags = merge(local.common_tags)
}

resource "azurerm_postgresql_database" "postgres" {
  name                = "cppd-postgres-db"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_key_vault_secret" "postgres_connection_string" {
  name         = "postgresconnection"
  value        = "postgres://${azurerm_postgresql_server.postgres.administrator_login}@${azurerm_postgresql_server.postgres.name}:${azurerm_postgresql_server.postgres.administrator_login_password}@host=${azurerm_postgresql_server.postgres.name}.postgres.database.azure.com"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id

  tags = merge(local.common_tags)
}