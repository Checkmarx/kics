package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_ros_stack[name]

    not common_lib.valid_key(resource, "template_body")
    not common_lib.valid_key(resource, "template_url")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ros_stack",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_ros_stack", name),
		"searchKey": sprintf("alicloud_ros_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'template_body' or Attribute 'template_url' should be set.",
		"keyActualValue": "Both Attribute 'template_body' and Attribute 'template_url' are undefined.",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack", name], []),
	}
}
