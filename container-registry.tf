resource "azurerm_container_registry" "container_registry" {
  name                = "EsDC${var.name}r"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Standard"
  admin_enabled       = true
  tags = { 
    Branch = azurerm_resource_group.resource_group.tags.Branch
    Classification = azurerm_resource_group.resource_group.tags.Classification
    Directorate = azurerm_resource_group.resource_group.tags.Directorate
    Environment = azurerm_resource_group.resource_group.tags.Environment
    Project = azurerm_resource_group.resource_group.tags.Project
    ServiceOwner = azurerm_resource_group.resource_group.tags.ServiceOwner
  }
}

output "container_registry_id" {
  value = azurerm_container_registry.container_registry.id
}

output "container_registry_login_server" {
  value = azurerm_container_registry.container_registry.login_server
}

output "container_registry_admin_username" {
  value = azurerm_container_registry.container_registry.admin_username
}

output "container_registry_admin_password" {
  value = azurerm_container_registry.container_registry.admin_password
}

output "container_registry_name" {
  value = azurerm_container_registry.container_registry.name
}
