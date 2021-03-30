package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_lambda_permission[name]

	resource.action != "lambda:InvokeFunction"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_lambda_permission[%s].action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[name].action is 'lambda:InvokeFunction'", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[name].action is %s", [name, resource.action]),
	}
}
