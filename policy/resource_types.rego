package resource_types

import data.terraform_helper as dth

name_policy_exempt_types = { 
    "azurerm_postgresql_database",
    "azurerm_storage_container"
}


is_exempt_from_name_policy(resource_type) { 
    name_policy_exempt_types[resource_type]
}