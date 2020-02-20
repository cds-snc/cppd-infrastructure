
variable "environmentprefix" {
    default = "S"
}

variable "locationprefix" {
    default = "C"
}

variable "name" {
    default = "CPPD"
}


locals {
    nameprefix    = "Es${var.environmentprefix}${var.locationprefix}${var.name}"
    appserviceips = tolist(split(",", data.azurerm_app_service.app_service.possible_outbound_ip_addresses))
}

data "azurerm_resource_group" "resource_group" {
    name = "${local.nameprefix}rg"
}

data "azurerm_app_service" "app_service" {
    name                = "${local.nameprefix}appservice"
    resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_postgresql_server" "postgres" {
    name                = "${local.nameprefix}postgresql"
    resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_redis_cache" "session_store" {
    name                = "${local.nameprefix}cache"
    resource_group_name = data.azurerm_resource_group.resource_group.name
}