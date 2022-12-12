package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_launch_template[name]
	resource.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_launch_template",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_launch_template[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_launch_template[%s].encrypted should be true", [name]),
		"keyActualValue": sprintf("alicloud_launch_template[%s].encrypted is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_launch_template", name, "encrypted"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_launch_template[name]
	not common_lib.valid_key(resource, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_launch_template",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_launch_template[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_launch_template[%s] 'encrypted' should be defined and set to true", [name]),
		"keyActualValue": sprintf("alicloud_launch_template[%s] 'encrypted' argument is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_launch_template", name], []),
		"remediation": "encrypted = true",
		"remediationType": "addition",
	}
}
