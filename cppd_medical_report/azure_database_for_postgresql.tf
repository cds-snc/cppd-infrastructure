
resource "azurerm_postgresql_server" "postgres" {
  name                = "${lower(local.nameprefix)}postgresql"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku_name = "GP_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Disabled"
  }

  administrator_login          = local.pgadmin_account
  administrator_login_password = random_password.postgres_admin.result
  version                      = "11"
  ssl_enforcement              = "Enabled"

  tags = merge(local.common_tags)
}

resource "azurerm_postgresql_database" "postgres" {
  name                = "medicalreportdb"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
