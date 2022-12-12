package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource = input.document[i].resource.aws_lambda_function[name]

    resource.tracing_config.mode == "PassThrough"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_function[%s].tracing_config.mode", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name ,"tracing_config", "mode"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tracing_config.mode should be set to 'Active'", [name]),
		"keyActualValue":sprintf("aws_lambda_function[%s].tracing_config.mode is set to 'PassThrough'", [name]),
		"remediation": json.marshal({
			"before": "PassThrough",
			"after": "Active"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource = input.document[i].resource.aws_lambda_function[name]

	not common_lib.valid_key(resource, "tracing_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_function[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name ], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].tracing_config should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_lambda_function[%s].tracing_config is undefined or null", [name]),
		"remediation": "tracing_config {\n\t\tmode = Active\n\t}",
		"remediationType": "addition",
	}
}
