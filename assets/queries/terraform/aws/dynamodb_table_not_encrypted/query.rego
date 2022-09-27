package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_dynamodb_table[name]
	resource.server_side_encryption.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dynamodb_table",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}].server_side_encryption.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_dynamodb_table", name,"server_side_encryption","enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_dynamodb_table.server_side_encryption.enabled should be set to true",
		"keyActualValue": "aws_dynamodb_table.server_side_encryption.enabled is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_dynamodb_table[name]
	not common_lib.valid_key(resource, "server_side_encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dynamodb_table",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_dynamodb_table", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dynamodb_table.server_side_encryption.enabled should be set to true",
		"keyActualValue": "aws_dynamodb_table.server_side_encryption is missing",
		"remediation": "server_side_encryption {\n\t\t enabled = true \n\t }",
		"remediationType": "addition",
	}
}
