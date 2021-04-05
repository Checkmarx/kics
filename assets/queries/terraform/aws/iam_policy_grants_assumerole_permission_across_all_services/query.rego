package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_role[name]

	re_match("Service", resource.assume_role_policy)
	policy := commonLib.json_unmarshal(resource.assume_role_policy)
	object.get(policy.Statement[ix], "Effect", "Allow") != "Deny"
	terraLib.anyPrincipal(policy.Statement[ix])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy.Statement.Principal' doesn't contain '*'",
		"keyActualValue": "'assume_role_policy.Statement.Principal' contains '*'",
	}
}
