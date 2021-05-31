package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	terraLib.check_principal(statement.Principal)
	terraLib.check_action(statement.Action, "kms:*")
	statement.Resource == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy definition is correct", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy definition is incorrect", [name]),
	}
}
