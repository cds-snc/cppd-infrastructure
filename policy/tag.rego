package tags
import data.tf_helper as tfh

minimum_tags = {
    "Branch",
    "Classification",
    "Project",
    "Directorate",
    "Environment",
    "ServiceOwner"
    }

tags_contain_proper_keys(tags) {
    keys := {key | tags[key]}
    leftover := minimum_tags - keys
    leftover == set()
}


tags_contain_minimum_set[i] = resources {
    tags := tfh.changeset[i].change.after.tags
    resources := [ 
        resource | 
        resource := tfh.module_address[i];
        not tags_contain_proper_keys(tags)
    ]
}
