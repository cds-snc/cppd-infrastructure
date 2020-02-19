
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

  administrator_login          = "psqladmin"
  administrator_login_password = data.azurerm_key_vault_secret.plsql-admin-pass.value
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

resource "azurerm_postgresql_firewall_rule" "postgres_firewall_rule" {
  for_each            = toset(split(",", azurerm_app_service.app_service.possible_outbound_ip_addresses))
  name                = "appserviceip"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  start_ip_address    = each.value
  end_ip_address      = each.value
}