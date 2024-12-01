package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_lambda_function[name]
	vars := resource.environment.variables

	re_match("(A3T[A-Z0-9]|AKIA|ASIA)[A-Z0-9]{16}", vars[idx])

	result := {
		"documentId": document.id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_function[%s].environment.variables.%s", [name, idx]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'environment.variables' shouldn't contain AWS Access Key",
		"keyActualValue": "'environment.variables' contains AWS Access Key",
		"searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name, "environment", "variables", idx], []),
	}
}
