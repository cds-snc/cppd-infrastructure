resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${lower(local.nameprefix)}loganalytics"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"

  tags = merge(local.common_tags)
}