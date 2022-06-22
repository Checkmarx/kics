package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_ros_stack[name]
	
	not hasPolicy(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ros_stack",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_ros_stack", name),
		"searchKey": sprintf("alicloud_ros_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The stack should have the attribute 'stack_policy_body' or 'stack_policy_url' defined",
		"keyActualValue": "The stack has neither 'stack_policy_body' nor 'stack_policy_url' defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_ros_stack[name]
	
	not hasPolicyDuringUpdate(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ros_stack",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_ros_stack", name),
		"searchKey": sprintf("alicloud_ros_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The stack should have the attribute 'stack_policy_during_update_body' or 'stack_policy_during_update_url' defined",
		"keyActualValue": "The stack has neither 'stack_policy_during_update_body' nor 'stack_policy_during_update_url' defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack", name], []),
	}
}

hasPolicy(resource){
	common_lib.valid_key(resource, "stack_policy_body")
}else{
	common_lib.valid_key(resource, "stack_policy_url")
}

hasPolicyDuringUpdate(resource){
	common_lib.valid_key(resource, "stack_policy_during_update_body")
}else{
	common_lib.valid_key(resource, "stack_policy_during_update_url")
}
