package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	pwPolicy := task["community.aws.iam_password_policy"]

	searchKey := checkAllowPass(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}%s", [task.name, searchKey]),
		"issueType": issueType(searchKey),
		"keyExpectedValue": "community.aws.iam_password_policy should have the property 'allow_pw_change/allow_password_change' true",
		"keyActualValue": "community.aws.iam_password_policy has the property 'allow_pw_change/allow_password_change' undefined or false",
	}
}

issueType(str) = "MissingAttribute" {
	str == ""
} else = "WrongValue" {
	true
}

checkAllowPass(pwPolicy) = ".allow_pw_change" {
	isFalse(pwPolicy.allow_pw_change)
} else = ".allow_password_change" {
	isFalse(pwPolicy.allow_password_change)
} else = "" {
	not pwPolicy.allow_pw_change
	not pwPolicy.allow_password_change
} else = "none" {
	true
}

isFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
