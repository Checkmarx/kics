package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	efs := input.document[i].resource.aws_efs_file_system[name]
	efs.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(efs, name),
		"searchKey": sprintf("aws_efs_file_system[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].encrypted' is true", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].encrypted' is false", [name]),
	}
}

CxPolicy[result] {
	efs := input.document[i].resource.aws_efs_file_system[name]
	not common_lib.valid_key(efs, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(efs, name),
		"searchKey": sprintf("aws_efs_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].encrypted' is defined and not null", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].encrypted' is undefined or null", [name]),
	}
}
