package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_athena_database[name]
	object.get(resource, "encryption_configuration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_athena_database[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_database[{{%s}}] encryption_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_athena_database[{{%s}}] encryption_configuration is missing", [name]),
	}
}
