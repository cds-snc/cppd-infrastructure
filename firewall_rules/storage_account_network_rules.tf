resource "azurerm_storage_account_network_rules" "storage_account_firewall_rules" {
    resource_group_name  = data.azurerm_resource_group.resource_group.name
    storage_account_name = data.azurerm_storage_account.storage_account.name
    
    default_action             = "Deny"
    ip_rules                   = local.appserviceips
}