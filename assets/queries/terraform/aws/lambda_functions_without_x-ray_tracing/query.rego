package Cx

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

	object.get(resource, "tracing_config", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lambda_function[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tracing_config is defined", [name]),
		"keyActualValue": sprintf("aws_lambda_function[%s].tracing_config is undefined", [name]),
	}
}
