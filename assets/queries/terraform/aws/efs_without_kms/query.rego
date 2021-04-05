package Cx

CxPolicy[result] {
	efs := input.document[i].resource.aws_efs_file_system[name]
	not efs.kms_key_id

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_efs_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].kms_key_id' is defined'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].kms_key_id' is undefined", [name]),
	}
}
