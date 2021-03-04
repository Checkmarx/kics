package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["community.aws.iam_password_policy"]

	object.get(policy, "require_lowercase", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_lowercase' set and true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_lowercase' undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["community.aws.iam_password_policy"]

	ansLib.isAnsibleFalse(policy.require_lowercase)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase is true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase is false", [task.name]),
	}
}
