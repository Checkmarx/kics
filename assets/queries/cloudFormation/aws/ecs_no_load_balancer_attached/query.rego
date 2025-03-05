package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	not resource.Properties.LoadBalancers

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancers' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancers' is not defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.LoadBalancers
	check_array_size(resource.Properties.LoadBalancers)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoadBalancers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancers' should not be empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancers' is empty", [name]),
	}
}

check_array_size(array_obj) {
	is_array(array_obj)
	count(array_obj) == 0
}
