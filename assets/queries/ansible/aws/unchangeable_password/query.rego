package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	pwPolicy := task["community.aws.iam_password_policy"]
	pwPolicyName := task.name

	searchKey := checkAllowPass(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}%s", [pwPolicyName, searchKey]),
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
