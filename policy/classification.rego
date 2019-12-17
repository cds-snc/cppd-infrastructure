package classifications

import data.tf_helper as tfh

classification_codes = { 
    "ULL",
    "UMM",
    "UHH",
    "PBMM"
}

valid_code[classification] { 
    classification := classification_codes[_]
}

no_valid_classification_set[i] = resources { 
    classification := tfh.changeset[i].change.after.tags["Classification"]
    resources := [ 
        resource | 
        resource := tfh.module_address[i];
        not valid_code[classification]
    ]
}

