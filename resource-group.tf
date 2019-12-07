resource "azurerm_resource_group" "resource_group" {
  name     = "EsDC${var.name}rg"
  location = var.location

  tags = { 
    Branch = "IITB"
    Classification = "Unclassified"
    Directorate = "BOSS"
    Environment = "Development"
    Project = "CPP-D"
    ServiceOwner = "calvin.rodo@014gc.onmicrosoft.com"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}
