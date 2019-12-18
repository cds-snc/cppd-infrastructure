package tf_helper 

changeset[i] = changeset { 
    changeset := input.resource_changes[i]
}
module_address[i] = address {
    address := changeset[i].address
}