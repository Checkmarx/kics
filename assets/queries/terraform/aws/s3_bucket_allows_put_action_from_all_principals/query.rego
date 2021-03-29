package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	resource := input.document[i].resource[pl[r]][name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	terraLib.anyPrincipal(statement)
	commonLib.containsOrInArrayContains(statement.Action, "put")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [pl[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'Put' action", [pl[r], name]),
		"keyActualValue": sprintf("%s[%s].policy.Action is a 'Put' action", [pl[r], name]),
	}
}
