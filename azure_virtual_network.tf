resource "azurerm_virtual_network" "virtual_network" {
  name                = "${lower(local.nameprefix)}vnet"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  tags = merge(local.common_tags)
}

resource "azurerm_subnet" "subnet" {
  name                 = "${lower(local.nameprefix)}subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefix       = "10.0.1.0/24"
  # security_group = "${azurerm_network_security_group.example.id}"
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}