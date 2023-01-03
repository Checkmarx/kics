package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_lambda_permission[name]

	contains(resource.principal, "*")

	result := {
		"documentId": document.id,
		"resourceType": "aws_lambda_permission",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_permission[%s].principal", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[%s].principal shouldn't contain a wildcard", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[%s].principal contains a wildcard", [name]),
	}
}
