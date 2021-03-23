package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.aws_kms", "aws_kms"}
	aws_kms := task[modules[m]]
	ansLib.checkState(aws_kms)

	policy_exists := object.get(aws_kms, "policy", "undefined") != "undefined"
	statement = aws_kms.policy.Statement[_]
	check_permission(statement) == true

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_kms.policy is correct",
		"keyActualValue": "aws_kms.policy is incorrect, the policy statement is too exposed",
	}
}

check_permission(statement) {
	statement.Principal.AWS == "*"
	statement.Action[i] == "kms:*"
	statement.Resource == "*"
}
