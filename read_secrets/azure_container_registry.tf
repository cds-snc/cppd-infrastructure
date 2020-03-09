
data "azurerm_container_registry" "container_registry" {
  name                = "EsSCCPPDr"
  resource_group_name = "EsSCCPPDrg"
}

output "container_registry_login_server" {
  value = data.azurerm_container_registry.container_registry.login_server
}

output "container_registry_admin_username" {
  value = data.azurerm_container_registry.container_registry.admin_username
}