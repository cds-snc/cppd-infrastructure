package main 

import data.names as names
import data.location as location
import data.tags as tags
import data.branch_codes as bt
import data.environments as env
import data.classifications as class


deny[msg] { 
    resources := class.no_valid_classification_set[_]
    resources != []
    msg := sprintf("Invalid Classification: %v",[resources])
}

deny[msg] { 
    resources := env.no_valid_environment_set[_]
    resources != []
    msg := sprintf("Invalid Environment: %v",[resources])
}

deny[msg] { 
    resources := bt.no_valid_branch_code_set[_]
    resources != []
    msg := sprintf("Invalid Branch Code: %v",[resources])
}

deny[msg] { 
    resources := location.outside_canada[_]
    resources != []
    msg := sprintf("Invalid resource location only Canada is allowed: %v",[resources])
}

deny[msg] { 
    resources := tags.environments_other_than_development[_]
    resources != []
    msg := sprintf("Only development environments allowed: %v",[resources])
}

deny[msg] { 
    resources := names.resource_groups_with_invalid_suffix[_] 
    resources != []
    msg := sprintf("Invalid resource group suffix for the following: %v",[resources])
}

deny[msg] {
    resources := tags.tags_contain_minimum_set[_]
    resources != []
    msg := sprintf("Invalid tags (missing minimum required tags) for the following resources: %v", [resources])
}

deny[msg] {
    resources := names.names_with_invalid_prefix[_]
    resources != []
    msg := sprintf("Invalid name Prefix (should be EsDC): %v", [resources])
}

