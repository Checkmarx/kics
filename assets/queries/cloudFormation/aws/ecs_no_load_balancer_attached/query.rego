package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECS::Service"
	not resource.Properties.LoadBalancers

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancers' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancers' is not defined", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.LoadBalancers
	check_size(resource.Properties.LoadBalancers)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoadBalancers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancers' should not be empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancers' is empty", [name]),
	}
}

check_size(array) {
	is_array(array)
	count(array) == 0
}
