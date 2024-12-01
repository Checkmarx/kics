package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_ros_stack[name]

	not common_lib.valid_key(resource, "notification_urls")

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_ros_stack",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_ros_stack", name),
		"searchKey": sprintf("alicloud_ros_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "stack 'notification_urls' should be defined",
		"keyActualValue": "stack 'notification_urls' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack", name], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_ros_stack[name]
	count(resource.notification_urls) == 0

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_ros_stack",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_ros_stack", name),
		"searchKey": sprintf("alicloud_ros_stack[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "stack 'notification_urls' should have urls",
		"keyActualValue": "stack 'notification_urls' is empty",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack", name, "notification_urls"], []),
	}
}
