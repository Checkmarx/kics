package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	terraLib.has_wildcard(statement, "kms:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy does not have wildcard in 'Action' or 'Principal'", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy has wildcard in 'Action' or 'Principal'", [name]),
	}
}
