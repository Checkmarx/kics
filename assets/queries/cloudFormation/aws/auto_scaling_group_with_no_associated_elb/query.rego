package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::AutoScaling::AutoScalingGroup"
	not common_lib.valid_key(resource.Properties, "LoadBalancerNames")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' is not defined", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::AutoScaling::AutoScalingGroup"
	elbs := resource.Properties.LoadBalancerNames
	check_size(elbs)

	result := {
		"documentId": doc.id,
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
