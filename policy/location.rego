package location
import data.tf_helper as dth

in_canada(location) { 
    re_match("^(canadaeast|canadacentral)$",location)
}
outside_canada = resources { 
    resources := [
        resource | 
        not in_canada(dth.changeset[i].change.after.location)
        resource := dth.module_address[i]
    ]
}