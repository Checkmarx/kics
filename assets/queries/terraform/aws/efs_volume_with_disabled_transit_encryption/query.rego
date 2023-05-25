package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_efs_file_system[name]
	ans := resource.transit_encryption
	not ans = "ENABLED"
	

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_efs_file_system[%s].transit_encryption", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].transit_encryption should be set to 'ENABLED'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].transit_encryption is set to '%s'", [name, ans]),
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system", name, "transit_encryption"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_efs_file_system[name]
	not resource.transit_encryption	

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_efs_file_system[%s].transit_encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].transit_encryption should be set to ENABLED", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].transit_encryption is not set", [name, ]),
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system", name], []),
	}
}