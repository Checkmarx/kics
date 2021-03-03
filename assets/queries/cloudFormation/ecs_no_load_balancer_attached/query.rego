package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	not resource.Properties.LoadBalancers

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancers' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancers' is not defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.LoadBalancers
	check_size(resource.Properties.LoadBalancers)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoadBalancers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancers' is not empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancers' is empty", [name]),
	}
}

check_size(array) {
	is_array(array)
	count(array) == 0
}
