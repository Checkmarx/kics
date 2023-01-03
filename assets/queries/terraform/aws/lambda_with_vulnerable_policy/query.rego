package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_lambda_permission[name]

	resource.action == "lambda:*"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lambda_permission",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_permission[%s].action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[%s].action should not have wildcard", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[%s].action has wildcard", [name]),
	}
}
