package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	expr := input.document[i].resource.aws_iam_account_password_policy[name]
	not expr.max_password_age

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(expr, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'max_password_age' should exist",
		"keyActualValue": "'max_password_age' is missing",
		"remediation": "max_password_age = 90",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	expr := input.document[i].resource.aws_iam_account_password_policy[name]
	expr.max_password_age > 90

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(expr, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name, "max_password_age"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_password_age' should be lower than 90",
		"keyActualValue": "'max_password_age' is higher than 90",
		"remediation": json.marshal({
			"before": sprintf("%d", [expr.max_password_age]),
			"after": "90"
		}),
		"remediationType": "replacement",
	}
}
