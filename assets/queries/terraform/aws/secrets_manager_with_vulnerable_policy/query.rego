package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_secretsmanager_secret_policy[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	terraLib.has_wildcard(statement, "secretsmanager:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_secretsmanager_secret_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_secretsmanager_secret_policy[%s].policy does not have wildcard in 'Principal' and 'Action'", [name]),
		"keyActualValue": sprintf("aws_secretsmanager_secret_policy[%s].policy has wildcard in 'Principal' and 'Action'", [name]),
	}
}
