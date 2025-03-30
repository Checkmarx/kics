package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

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
	check_array_size(elbs)

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

check_array_size(array_obj) {
	is_array(array_obj)
	count(array_obj) == 0
}
