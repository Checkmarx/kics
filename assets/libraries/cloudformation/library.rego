package generic.cloudformation

getResourcesByType(resources, type) = list {
    list = [resource | resources[i].Type == type; resource := resources[i]]
}
