
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

resource "azurerm_monitor_diagnostic_setting" "database_diagnostic_settings" {
  name                           = "${local.nameprefix}postgresdiagnostics"
  target_resource_id             = azurerm_postgresql_database.postgres.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_destination_type = "Dedicated"

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = true
      days    = 7
    }
  }

  log {
    category = "PostgreSQLLogs"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 7
    }
  }

  log {
    category = "QueryStoreRuntimeStatistics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 7
    }
  }

  log {
    category = "QueryStoreWaitStatistics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

resource "azurerm_postgresql_configuration" "db_congif_log_level" {
  name                = "client_min_messages"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  value               = "LOG"
}

resource "azurerm_postgresql_configuration" "db_congif_retention" {
  name                = "log_retention_days"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  value               = "7"
}

resource "azurerm_postgresql_configuration" "db_congif_log_statement" {
  name                = "log_statement"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_postgresql_server.postgres.name
  value               = "ALL"
}