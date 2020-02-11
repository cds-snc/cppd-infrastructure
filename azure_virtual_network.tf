resource "azurerm_virtual_network" "virtual_network" {
  name                = "${lower(local.nameprefix)}vnet"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["192.168.0.0/24"]

  tags = merge(local.common_tags)
}

resource "azurerm_subnet" "subnet" {
  name                      = "${lower(local.nameprefix)}subnet"
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = "192.168.0.0/24"
  service_endpoints         = ["Microsoft.Sql", "Microsoft.Web"]

  # will be removed when AzureRM Provider 2.0 is released
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}