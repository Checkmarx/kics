package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.iam_password_policy", "iam_password_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	object.get(policy, "require_lowercase", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.require_lowercase", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_password_policy.require_lowercase is set and true",
		"keyActualValue": "iam_password_policy.require_lowercase is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	ansLib.isAnsibleFalse(policy.require_lowercase)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.require_lowercase", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_password_policy.require_lowercase is true",
		"keyActualValue": "iam_password_policy.require_lowercase is false",
	}
}
