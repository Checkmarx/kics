package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_athena_database[name]
	not common_lib.valid_key(resource, "encryption_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_athena_database[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_database[{{%s}}] encryption_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_athena_database[{{%s}}] encryption_configuration is missing", [name]),
	}
}
