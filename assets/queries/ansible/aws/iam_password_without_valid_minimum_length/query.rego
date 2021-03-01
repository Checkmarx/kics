package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task = ansLib.tasks[id][t]
	policy = task["community.aws.iam_password_policy"]

	not getName(policy)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'min_pw_length/minimum_password_length' is set and no less than 8",
		"keyActualValue": "'min_pw_length/minimum_password_length' is undefined",
	}
}

CxPolicy[result] {
	task = ansLib.tasks[id][t]
	policy = task["community.aws.iam_password_policy"]

	variableName = getName(policy)
	to_number(policy[variableName]) < 8

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}.{{min_pw_length}}", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is set and no less than 8", [variableName]),
		"keyActualValue": sprintf("'%s' is less than 8", [variableName]),
	}
}

getName(policyBody) = "min_pw_length" {
	object.get(policyBody, "min_pw_length", "undefined") != "undefined"
} else = "minimum_password_length" {
	object.get(policyBody, "minimum_password_length", "undefined") != "undefined"
} else = false {
	true
}
