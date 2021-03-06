resource "azurerm_resource_group" "resource_group" {
  name     = "${local.nameprefix}rg"
  location = var.location

  tags = merge(local.common_tags)
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}
