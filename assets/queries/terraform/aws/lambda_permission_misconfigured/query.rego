package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_lambda_permission[name]

	resource.action != "lambda:InvokeFunction"

	result := {
		"documentId": document.id,
		"resourceType": "aws_lambda_permission",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_permission[%s].action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[name].action is 'lambda:InvokeFunction'", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[name].action is %s", [name, resource.action]),
	}
}
