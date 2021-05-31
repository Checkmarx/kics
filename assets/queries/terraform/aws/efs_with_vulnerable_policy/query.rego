package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_efs_file_system_policy[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	check_principal(statement.Principal)
	statement.Action[_] == "elasticfilesystem:*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_efs_file_system_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system_policy[%s].policy definition is correct", [name]),
		"keyActualValue": sprintf("aws_efs_file_system_policy[%s].policy definition is incorrect", [name]),
	}
}

check_principal(principal) {
	is_string(principal) == true
	principal == "*"
}

check_principal(principal) {
	is_object(principal) == true
	principal.AWS == "*"
}
