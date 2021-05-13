package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_athena_workgroup[name]
	object.get(resource, "configuration", "undefined") == "undefined"

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
	object.get(resource.configuration, "result_configuration", "undefined") == "undefined"

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
	object.get(resource.configuration.result_configuration, "encryption_configuration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration.encryption_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_athena_workgroup[{{%s}}].configuration.result_configuration.encryption_configuration is missing", [name]),
	}
}
