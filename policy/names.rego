package names
import data.tf_helper as dth
import data.location as l
import data.resource_types as rt
import data.tags as t

resource_name[i] = resource_name { 
    resource_name := dth.changeset[i].change.after.name
} 

resource_type[i] = resource_type { 
    resource_type := dth.changeset[i].type
}

has_esdc_prefix(name) { 
    re_match("^(Es|es)[A-Za-z]*",name)
}

has_sandbox_prefix(name) { 
    re_match("^(Es|es)(S|s)[A-Za-z]*$",name)
}

has_canada_central_prefix(name) { 
    re_match("^(Es|es)[A-Za-z](C|c)[A-Za-z]*$", name)
}

has_canada_east_prefix(name) { 
    re_match("^(Es|es)[A-Za-z](E|e)[A-Za-z]*$", name)
}

has_resource_group_suffix(name) { 
    re_match("[A-Za-z]*rg$",name)
}

invalid_sandbox_prefix[i] = resources { 
    resource_names :=  resource_name[i]
    resource_types := resource_type[i]
    tags := dth.changeset[i].change.after.tags
    resources := [
        resource | 
        resource := dth.module_address[i]; 
        not has_sandbox_prefix(resource_names)
        tags["Sandbox"]
        not rt.is_exempt_from_name_policy(resource_types)
    ]
}

invalid_canada_central_prefix[i] = resources { 
    resource_names :=  resource_name[i]
    locations := l.location[i]
    resource_types := resource_type[i]
    resources := [
        resource | 
        resource := data.tf_helper.module_address[i]; 
        not has_canada_central_prefix(resource_names)
        l.is_canada_central(locations)
        not rt.is_exempt_from_name_policy(resource_types)
    ]
}

invalid_canada_east_prefix[i] = resources { 
    resource_names :=  resource_name[i]
    resource_types := resource_type[i]
    resources := [
        resource | 
        resource := data.tf_helper.module_address[i]; 
        not has_canada_east_prefix(resource_names)
        l.is_canada_east(resource_names)
        not rt.is_exempt_from_name_policy(resource_types)
    ]
}
names_with_invalid_prefix[i] = resources {
    resource_names :=  resource_name[i]
    resource_types := resource_type[i]
    resources := [
        resource | 
        resource := data.tf_helper.module_address[i];
        not has_esdc_prefix(resource_names)
        not rt.is_exempt_from_name_policy(resource_types)
    ]
}

resource_groups_with_invalid_suffix[i] = resources {
    resource_names :=  resource_name[i]
    resource_types := resource_type[i]
    resources := [
        resource | 
        resource := dth.tf_helper.module_address[i];
        resource_types == "azurerm_resource_group" 
        not has_resource_group_suffix(resource_names)
    ]
}