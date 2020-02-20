resource "azurerm_virtual_network" "virtual_network" {
  name                = "${lower(local.nameprefix)}vnet"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = [var.vnet_address_space]

  tags = merge(local.common_tags)
}

resource "azurerm_subnet" "subnet" {
  name                      = "${lower(local.nameprefix)}subnet"
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.vnet_address_space
  service_endpoints         = ["Microsoft.Sql"]

  # will be removed when AzureRM Provider 2.0 is released
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

### Postgres Vnet Rule ###
resource "azurerm_postgresql_virtual_network_rule" "postgres_vnet_rule" {
  name                                 = "${lower(local.nameprefix)}postgresqlvnetrule"
  resource_group_name                  = azurerm_resource_group.resource_group.name
  server_name                          = azurerm_postgresql_server.postgres.name
  subnet_id                            = azurerm_subnet.subnet.id
  ignore_missing_vnet_service_endpoint = true
}

### Redis Vnet Rule ###