resource "azurerm_container_registry" "container_registry" {
  name                = "${local.nameprefix}r"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Standard"
  admin_enabled       = true
  tags                = merge(local.common_tags)
}

output "container_registry_login_server" {
  value = azurerm_container_registry.container_registry.login_server
}

output "container_registry_admin_username" {
  value = azurerm_container_registry.container_registry.admin_username
}
