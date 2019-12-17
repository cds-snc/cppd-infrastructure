resource "azurerm_resource_group" "resource_group" {
  name     = "EsDC${var.name}rg"
  location = var.location

  tags = { 
    Branch = "IITB"
    Classification = var.classification
    Directorate = "BOSS"
    Environment = var.environment
    Project = "CPP-D"
    ServiceOwner = var.service_owner
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}
