package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	password_policy := document.resource.aws_iam_account_password_policy[name]
	not password_policy.minimum_password_length

	result := {
		"documentId": document.id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(password_policy, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'minimum_password_length' should be set and no less than 14",
		"keyActualValue": "'minimum_password_length' is undefined",
		"remediation": "minimum_password_length = 14",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	password_policy := document.resource.aws_iam_account_password_policy[name]
	min_length := password_policy.minimum_password_length
	to_number(min_length) < 14

	result := {
		"documentId": document.id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(password_policy, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name, "minimum_password_length"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimum_password_length' should be set and no less than 14",
		"keyActualValue": "'minimum_password_length' is less than 14",
		"remediation": json.marshal({
			"before": sprintf("%d", [min_length]),
			"after": "14",
		}),
		"remediationType": "replacement",
	}
}
