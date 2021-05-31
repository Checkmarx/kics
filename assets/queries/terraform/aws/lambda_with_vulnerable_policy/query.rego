package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_lambda_permission[name]

	resource.action == "lambda:*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lambda_permission[%s].action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[%s].action does not have wildcard", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[%s].action has wildcard", [name]),
	}
}
