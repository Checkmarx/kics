package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aws_kms := task["community.aws.aws_kms"]

	policy_exists := object.get(aws_kms, "policy", "undefined") != "undefined"
	statement = aws_kms.policy.Statement[_]
	check_permission(statement) == true

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_kms}}.policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.aws_kms}}.policy is correct", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.aws_kms}}.policy is incorrect, the policy statement is too exposed", [task.name]),
	}
}

check_permission(statement) {
	statement.Principal.AWS == "*"
	statement.Action[i] == "kms:*"
	statement.Resource == "*"
}
