package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_lambda_permission[name]

	contains(resource.principal, "*")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_lambda_permission[%s].principal", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[%s].principal doesn't contain a wildcard", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[%s].principal contains a wildcard", [name]),
	}
}
