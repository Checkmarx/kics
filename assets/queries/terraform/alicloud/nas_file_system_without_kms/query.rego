package Cx

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_nas_file_system[name]
	resource.encrypt_type == "2"
	not resource.kms_key_id

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_nas_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_nas_file_system[%s].kms_key_id' is defined'", [name]),
		"keyActualValue": sprintf("alicloud_nas_file_system[%s].kms_key_id' is undefined", [name]),
	}
}
