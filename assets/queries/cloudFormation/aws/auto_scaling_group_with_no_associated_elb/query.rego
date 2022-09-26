package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::AutoScaling::AutoScalingGroup"
	not common_lib.valid_key(resource.Properties, "LoadBalancerNames")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' is not defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::AutoScaling::AutoScalingGroup"
	elbs := resource.Properties.LoadBalancerNames
	check_size(elbs)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoadBalancerNames", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' should not be empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' is empty", [name]),
	}
}

check_size(array) {
	is_array(array)
	count(array) == 0
}
