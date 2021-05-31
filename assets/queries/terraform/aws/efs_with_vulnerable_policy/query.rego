package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_efs_file_system_policy[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	terraLib.has_wildcard(statement, "elasticfilesystem:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_efs_file_system_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system_policy[%s].policy does not have wildcard in 'Action' or 'Principal'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system_policy[%s].policy has wildcard in 'Action' or 'Principal'", [name]),
	}
}
