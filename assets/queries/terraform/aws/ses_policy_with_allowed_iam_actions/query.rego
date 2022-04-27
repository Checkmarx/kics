package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ses_identity_policy[name]

	terra_lib.allows_action_from_all_principals(resource.policy, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ses_identity_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy' does not allow IAM actions to all principals",
		"keyActualValue": "'policy' allows IAM actions to all principals",
		"searchLine": common_lib.build_search_line(["resource", "aws_ses_identity_policy", name, "policy"], []),
	}
}
