provider "azurerm" {
  version = "= 2.0.0"
  features {}
}

data "azurerm_key_vault" "key_vault" {
  name                = "EsSCCPPDkv"
  resource_group_name = "EsSCCPPDrg"
}

data "azurerm_key_vault_secret" "pg_admin_pass" {
  name         = "psqladmin"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "pg_connection_string" {
  name         = "postgresconnection"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redisconnection"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "docker_password" {
  name         = "dockerpword"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

output "pg_admin_password" {
  value = data.azurerm_key_vault_secret.pg_admin_pass.value
}

output "pg_connection_string" {
  value = data.azurerm_key_vault_secret.pg_connection_string.value
}

output "redis_connection_string" {
  value = data.azurerm_key_vault_secret.redis_connection_string.value
}

output "docker_password" {
  value = data.azurerm_key_vault_secret.docker_password.value
}