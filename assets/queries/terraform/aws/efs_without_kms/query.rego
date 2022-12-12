package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	efs := input.document[i].resource.aws_efs_file_system[name]
	not efs.kms_key_id

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(efs, name),
		"searchKey": sprintf("aws_efs_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].kms_key_id' should be defined'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].kms_key_id' is undefined", [name]),
	}
}
