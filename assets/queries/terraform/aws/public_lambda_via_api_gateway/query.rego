package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_lambda_function[name]
	permissionResource := input.document[i].resource.aws_lambda_permission[permissionName]

	contains(permissionResource.function_name, concat(".", ["aws_lambda_function", name]))
	permissionResource.action == "lambda:InvokeFunction"
	principalAllowAPIGateway(permissionResource.principal)
	re_match("/\\*/\\*$", permissionResource.source_arn)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lambda_permission",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_permission[%s].source_arn", [permissionName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'source_arn' should not equal '/*/*'",
		"keyActualValue": "'source_arn' is equal '/*/*'",
	}
}

principalAllowAPIGateway(principal) = allow {
	principal == "*"
	allow = true
} else = allow {
	principal == "apigateway.amazonaws.com"
	allow = true
}
