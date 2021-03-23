package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy

	out := commonLib.json_unmarshal(policy)
	aws := out.Statement[idx].Principal.AWS

	commonLib.allowsAllPrincipalsToAssume(aws, out.Statement[idx])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' does not contain ':root'",
		"keyActualValue": "'assume_role_policy.Statement.Principal.AWS' contains ':root'",
	}
}
