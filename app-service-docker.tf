resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "EsDC${var.name}asp"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "B1"
  }

  tags = { 
    Branch = "IITB"
    Classification = "Unclassified"
    Directorate = "BOSS"
    Environment = "Development"
    Project = "CPP-D"
    ServiceOwner = "calvin.rodo@014gc.onmicrosoft.com"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "EsDC${var.name}appservice"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.container_registry.login_server}/${var.docker_image}:${var.docker_image_tag}"
    http2_enabled    = true
    always_on        = true
  }

  app_settings = {
    "DOCKER_ENABLE_CI"                = "true"
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.container_registry.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.container_registry.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.container_registry.admin_password
  }

  tags = { 
    Branch = "IITB"
    Classification = "Unclassified"
    Directorate = "BOSS"
    Environment = "Development"
    Project = "CPP-D"
    ServiceOwner = "calvin.rodo@014gc.onmicrosoft.com"
  }
}