package resource_types

import data.terraform_helper as dth

name_policy_exempt_types = { 
    "azurerm_postgresql_database",
    "azurerm_storage_container",
    "azurerm_key_vault_secret",
    "azurerm_postgresql_configuration"
}


is_exempt_from_name_policy(resource_type) { 
    name_policy_exempt_types[resource_type]
}