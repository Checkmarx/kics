package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.iam_password_policy", "iam_password_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	not getName(policy)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "iam_password_policy.min_pw_length/minimum_password_length should be set and no less than 8",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.{{min_pw_length}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("iam_password_policy.%s should be set and no less than 8", [variableName]),
		"keyActualValue": sprintf("iam_password_policy.%s is less than 8", [variableName]),
	}
}

getName(policyBody) = "min_pw_length" {
	common_lib.valid_key(policyBody, "min_pw_length")
} else = "minimum_password_length" {
	common_lib.valid_key(policyBody, "minimum_password_length")
} else = false {
	true
}
