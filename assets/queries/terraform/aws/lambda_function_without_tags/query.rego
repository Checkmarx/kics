package Cx

CxPolicy[result] {
	document = input.document[i]
	lambda = document.resource.aws_lambda_function[name]

	object.get(lambda, "tags", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_lambda_function[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tags is defined", [name]),
		"keyActualValue": sprintf("aws_lambda_function[%s].tags is undefined", [name]),
	}
}
