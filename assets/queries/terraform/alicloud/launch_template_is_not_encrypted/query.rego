package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_launch_template[name]
	resource.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_launch_template[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_launch_template[%s].encrypted to be true", [name]),
		"keyActualValue": sprintf("alicloud_launch_template[%s].encrypted is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_launch_template", name, "encrypted"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_launch_template[name]
	not common_lib.valid_key(resource, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_launch_template[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_launch_template[%s] 'encrypted' should be defined and set to true", [name]),
		"keyActualValue": sprintf("alicloud_launch_template[%s] 'encrypted' argument is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_launch_template", name], []),
	}
}
