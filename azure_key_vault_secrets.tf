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

data "azurerm_key_vault_secret" "postgres_root_cert" {
  name         = "postgresrootcert"
  key_vault_id = data.azurerm_key_vault.central-key-vault.id
}