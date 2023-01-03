package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.iam_password_policy", "iam_password_policy"}
	pwPolicy := task[modules[m]]
	ansLib.checkState(pwPolicy)

	searchKey := checkAllowPass(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}%s", [task.name, modules[m], searchKey]),
		"issueType": issueType(searchKey),
		"keyExpectedValue": "iam_password_policy should have the property 'allow_pw_change/allow_password_change' true",
		"keyActualValue": "iam_password_policy has the property 'allow_pw_change/allow_password_change' undefined or false",
	}
}

issueType(str) = "MissingAttribute" {
	str == ""
} else = "IncorrectValue" {
	true
}

checkAllowPass(pwPolicy) = ".allow_pw_change" {
	ansLib.isAnsibleFalse(pwPolicy.allow_pw_change)
} else = ".allow_password_change" {
	ansLib.isAnsibleFalse(pwPolicy.allow_password_change)
} else = "" {
	not pwPolicy.allow_pw_change
	not pwPolicy.allow_password_change
} else = "none" {
	true
}
