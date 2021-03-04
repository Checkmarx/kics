package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["community.aws.iam_password_policy"]

	object.get(policy, "require_uppercase", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_uppercase' set and true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_uppercase' undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["community.aws.iam_password_policy"]

	ansLib.isAnsibleFalse(policy.require_uppercase)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase is true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase is false", [task.name]),
	}
}
