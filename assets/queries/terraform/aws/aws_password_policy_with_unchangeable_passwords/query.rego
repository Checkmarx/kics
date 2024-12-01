package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

# allow_users_to_change_password default is true
CxPolicy[result] {
	some document in input.document
	pol := document.resource.aws_iam_account_password_policy[name]
	pol.allow_users_to_change_password == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_iam_account_password_policy",
		"resourceName": tf_lib.get_resource_name(pol, name),
		"searchKey": sprintf("aws_iam_account_password_policy[%s].allow_users_to_change_password", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_account_password_policy", name, "allow_users_to_change_password"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'allow_users_to_change_password' should equal 'true'",
		"keyActualValue": "'allow_users_to_change_password' is equal 'false'",
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
