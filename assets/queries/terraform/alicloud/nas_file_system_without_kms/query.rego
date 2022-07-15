package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	not common_lib.valid_key(resource, "encrypt_type")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_nas_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_nas_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' should be defined and set to 2'", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_nas_file_system", name], []),
		"remediation": "encrypt_type = \"2\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	resource.encrypt_type != "2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_nas_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_nas_file_system[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' should be set to 2'", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' is not set to 2  ", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_nas_file_system", name, "encrypt_type"], []),
		"remediation": json.marshal({
			"before": resource.encrypt_type,
			"after": "2"
		}),
		"remediationType": "replacement",
	}
}
