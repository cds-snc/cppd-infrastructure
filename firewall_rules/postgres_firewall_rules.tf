
resource "azurerm_postgresql_firewall_rule" "postgres_firewall_rule" {
  count               = length(local.appserviceips)
  name                = "appserviceip${count.index}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  server_name         = lower(data.azurerm_postgresql_server.postgres.name)
  start_ip_address    = local.appserviceips[count.index]
  end_ip_address      = local.appserviceips[count.index]
}