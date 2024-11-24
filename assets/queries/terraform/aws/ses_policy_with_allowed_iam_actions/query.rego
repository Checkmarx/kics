package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_ses_identity_policy[name]

	tf_lib.allows_action_from_all_principals(resource.policy, "*")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_ses_identity_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ses_identity_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy' should not allow IAM actions to all principals",
		"keyActualValue": "'policy' allows IAM actions to all principals",
		"searchLine": common_lib.build_search_line(["resource", "aws_ses_identity_policy", name, "policy"], []),
	}
}
