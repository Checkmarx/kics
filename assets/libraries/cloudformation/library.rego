package generic.cloudformation

isCloudFormationFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
getResourcesByType(resources, type) = list {
    list = [resource | resources[i].Type == type; resource := resources[i]]
}
