package names
import data.tf_helper

has_esdc_prefix(name) { 
    re_match("^EsDC[A-Za-z]*",name)
}

has_resource_group_suffix(name) { 
    re_match("[A-Za-z]*rg$",name)
}

names_with_invalid_prefix[i] = resources {
    names := data.tf_helper.changeset[i].change.after.name
    resources := [
        resource | 
        resource := data.tf_helper.module_address[i];
        not has_esdc_prefix(names)
    ]
}

resource_groups_with_invalid_suffix[i] = resources {
    type := data.tf_helper.changeset[i].type
    resources := [
        resource | 
        resource := data.tf_helper.module_address[i];
        type == "azurerm_resource_group" 
        not has_resource_group_suffix(data.tf_helper.changeset[i].change.after.name)
    ]
}