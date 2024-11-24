package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_lambda_permission[name]

	resource.action == "lambda:*"

	result := {
		"documentId": document.id,
		"resourceType": "aws_lambda_permission",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_permission[%s].action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[%s].action should not have wildcard", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[%s].action has wildcard", [name]),
	}
}
