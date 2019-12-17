package branch_codes 
import data.tf_helper as tfh

codes = [ 
    "IITB",
    "CFO",
    "CS",
    "HRSB",
    "IAS",
    "LB",
    "POB",
    "PASR",
    "SE",
    "SSPB"
]

valid_branch[branch_code] { 
    branch_code := codes[_]
}

no_valid_branch_code_set[i] = resources { 
    branch := tfh.changeset[i].change.after.tags["Branch"]
    resources := [ 
        resource | 
        resource := tfh.module_address[i];
        not valid_branch[branch]
    ]
}