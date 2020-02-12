package environments 

import data.tf_helper as tfh

environments = [
    "LAB", # Laboratory
    "SBX", # Sandbox
    "Sandbox",
    "DEV", # Development
    "TST", # Test-QA
    "UAT", # User Acceptance Testing
    "SEC", # Security
    "PPD", # Pre-Production
    "PRD" # Production
]

valid_environment[environment] { 
    environment := environments[_]
}

no_valid_environment_set[i] = resources { 
    environment := tfh.changeset[i].change.after.tags["Environment"]
    resources := [ 
        resource | 
        resource := tfh.module_address[i];
        not valid_environment[environment]
    ]
}
