package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource = input.document[i].resource.aws_lambda_function[name]

    resource.tracing_config.mode == "PassThrough"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lambda_function[%s].tracing_config.mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tracing_config.mode is set to 'Active'", [name]),
		"keyActualValue":sprintf("aws_lambda_function[%s].tracing_config.mode is set to 'PassThrough'", [name]),
	}
}

CxPolicy[result] {
	resource = input.document[i].resource.aws_lambda_function[name]

	not common_lib.valid_key(resource, "tracing_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lambda_function[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tracing_config is defined and not null", [name]),
		"keyActualValue": sprintf("aws_lambda_function[%s].tracing_config is undefined or null", [name]),
	}
}
