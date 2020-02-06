data "azurerm_key_vault" "central-key-vault" {
  name                = "central-key-vault"
  resource_group_name = azurerm_resource_group.resource_group.name
}

data "azurerm_key_vault_secret" "plsql-admin-pass" {
  name         = "psqladmin"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id
}

resource "azurerm_postgresql_server" "postgres" {
  name                = "cppd-postgresql-server"
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
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

