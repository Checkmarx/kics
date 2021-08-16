package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document = input.document[i]
	lambda = document.resource.aws_lambda_function[name]

	not common_lib.valid_key(lambda, "tags")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_lambda_function[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tags is defined and not null", [name]),
		"keyActualValue": sprintf("aws_lambda_function[%s].tags is undefined or null", [name]),
	}
}
