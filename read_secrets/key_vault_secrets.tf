
data "azurerm_key_vault" "key_vault" {
  name                = "EsSCCPPDkv"
  resource_group_name = "EsSCCPPDrg"
}

data "azurerm_key_vault_secret" "storage_access_key" {
  name         = "storageAccessKey"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

output "storage_account_key" {
  value = data.azurerm_key_vault_secret.storage_access_key.value
}

data "azurerm_key_vault_secret" "pg_admin_pass" {
  name         = "psqladmin"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

output "pg_admin_password" {
  value = data.azurerm_key_vault_secret.pg_admin_pass.value
}

# data "azurerm_key_vault_secret" "pg_connection_string" {
#   name         = "postgresconnection"
#   key_vault_id = data.azurerm_key_vault.key_vault.id
# }

# output "pg_connection_string" {
#   value = data.azurerm_key_vault_secret.pg_connection_string.value
# }

data "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redisconnection"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

output "redis_connection_string" {
  value = data.azurerm_key_vault_secret.redis_connection_string.value
}

data "azurerm_key_vault_secret" "docker_password" {
  name         = "dockerpword"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

output "docker_password" {
  value = data.azurerm_key_vault_secret.docker_password.value
}
