package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	not common_lib.valid_key(password_policy, "password_reuse_prevention")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(password_policy, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'password_reuse_prevention' should be set with value 24",
		"keyActualValue": "'password_reuse_prevention' is undefined",
		"remediation": "password_reuse_prevention = 24",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
	rp := password_policy.password_reuse_prevention
	rp < 24

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(password_policy, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name, "password_reuse_prevention"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'password_reuse_prevention' should be 24",
		"keyActualValue": "'password_reuse_prevention' is lower than 24",
		"remediation": json.marshal({
			"before": sprintf("%d", [rp]),
			"after": "24"
		}),
		"remediationType": "replacement",
	}
}
