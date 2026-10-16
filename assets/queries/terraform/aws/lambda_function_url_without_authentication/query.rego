package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_lambda_function_url[name]
	resource.authorization_type == "NONE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lambda_function_url",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_function_url[%s].authorization_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_lambda_function_url[%s].authorization_type' should not be 'NONE'", [name]),
		"keyActualValue": sprintf("'aws_lambda_function_url[%s].authorization_type' is 'NONE', allowing unauthenticated invocations", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_lambda_function_url", name, "authorization_type"], []),
		"remediation": "authorization_type = \"AWS_IAM\"",
		"remediationType": "replacement",
	}
}
