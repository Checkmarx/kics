package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_athena_workgroup[name]
	not common_lib.valid_key(resource, "configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_athena_workgroup[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration.encryption_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_athena_workgroup[{{%s}}].configuration is missing", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_athena_workgroup[name]
	not common_lib.valid_key(resource.configuration, "result_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_athena_workgroup[{{%s}}].configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration.encryption_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration is missing", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_athena_workgroup[name]
	not common_lib.valid_key(resource.configuration.result_configuration, "encryption_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration.encryption_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration.encryption_configuration is missing", [name]),
	}
}
