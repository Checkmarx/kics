package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	resource.encrypt_type == "0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_nas_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_nas_file_system[%s].encrypt_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' should not be 0", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' is 0", [name]),
		"searchLine":common_lib.build_search_line(["resource", "alicloud_nas_file_system", name, "encrypt_type"], []),
		"remediation": json.marshal({
			"before": "0",
			"after": "2"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	not common_lib.valid_key(resource, "encrypt_type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_nas_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_nas_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' should be defined and the value different from 0 ", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' is undefined", [name]),
		"searchLine":common_lib.build_search_line(["resource", "alicloud_nas_file_system", name], []),
		"remediation": "encrypt_type = \"2\"",
		"remediationType": "addition",
	}
}
