package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_dynamodb_table[name]
	resource.server_side_encryption.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}].server_side_encryption.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_dynamodb_table.server_side_encryption.enabled is set to true",
		"keyActualValue": "aws_dynamodb_table.server_side_encryption.enabled is set to false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_dynamodb_table[name]
	not common_lib.valid_key(resource, "server_side_encryption")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dynamodb_table.server_side_encryption.enabled is set to true",
		"keyActualValue": "aws_dynamodb_table.server_side_encryption is missing",
	}
}
