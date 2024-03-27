package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.iam_password_policy", "iam_password_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	not common_lib.valid_key(policy, "require_numbers")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_password_policy.require_numbers set and true",
		"keyActualValue": "iam_password_policy.require_numbers undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	ansLib.isAnsibleFalse(policy.require_numbers)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.require_numbers", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_password_policy.require_numbers should be true",
		"keyActualValue": "iam_password_policy.require_numbers is false",
	}
}
