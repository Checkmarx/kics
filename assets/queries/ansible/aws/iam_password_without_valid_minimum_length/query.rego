package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.iam_password_policy", "iam_password_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	not getName(policy)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "iam_password_policy.min_pw_length/minimum_password_length is set and no less than 8",
		"keyActualValue": "iam_password_policy.min_pw_length/minimum_password_length is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	variableName := getName(policy)
	to_number(policy[variableName]) < 8

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.{{min_pw_length}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("iam_password_policy.%s is set and no less than 8", [variableName]),
		"keyActualValue": sprintf("iam_password_policy.%s is less than 8", [variableName]),
	}
}

getName(policyBody) = "min_pw_length" {
	object.get(policyBody, "min_pw_length", "undefined") != "undefined"
} else = "minimum_password_length" {
	object.get(policyBody, "minimum_password_length", "undefined") != "undefined"
} else = false {
	true
}
