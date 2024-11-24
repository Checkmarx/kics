package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	efs := document.resource.aws_efs_file_system[name]
	not efs.kms_key_id

	result := {
		"documentId": document.id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(efs, name),
		"searchKey": sprintf("aws_efs_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].kms_key_id' should be defined'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].kms_key_id' is undefined", [name]),
	}
}
