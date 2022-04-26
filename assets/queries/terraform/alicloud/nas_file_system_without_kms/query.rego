package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	not common_lib.valid_key(resource, "encrypt_type")
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_nas_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' should be defined and set to 2'", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].encrypt_type' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_nas_file_system", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	resource.encrypt_type != "2"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_nas_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].kms_key_id' should be set to 2'", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].kms_key_id' is not set to 2  ", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_nas_file_system", name, "encrypt_type"], []),
	}
}
