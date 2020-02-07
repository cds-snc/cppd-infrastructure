package location
import data.tf_helper as dth

location[i] = location { 
    location := dth.changeset[i].change.after.location
}

in_canada(location) { 
    re_match("^(canadaeast|canadacentral)$",location)
}

is_canada_central(location) { 
    re_match("^canadacentral$", location)
}

is_canada_east(location) { 
    re_match("^canadaeast$", location)
}

outside_canada = resources { 
    resources := [
        resource | 
        not in_canada(dth.changeset[i].change.after.location)
        resource := dth.module_address[i]
    ]
}