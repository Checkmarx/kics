package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_ros_stack[name]

    not common_lib.valid_key(resource, "template_body")
    not common_lib.valid_key(resource, "template_url")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ros_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'template_body' or Attribute 'template_url' to be set.",
		"keyActualValue": "Both Attribute 'template_body' and Attribute 'template_url' are undefined.",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack", name], []),
	}
}
