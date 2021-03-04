package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	pwPolicy := task["community.aws.iam_password_policy"]

	searchKey := checkPwMaxAge(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}%s", [task.name, searchKey]),
		"issueType": issueType(searchKey),
		"keyExpectedValue": "community.aws.iam_password_policy should have the property 'pw_max_age/password_max_age' lower than 90",
		"keyActualValue": "community.aws.iam_password_policy has the property 'pw_max_age/password_max_age' unassigned or greater than 90",
	}
}

issueType(str) = "MissingAttribute" {
	str == ""
} else = "IncorrectValue" {
	true
}

checkPwMaxAge(pwPolicy) = ".pw_max_age" {
	pwPolicy.pw_max_age > 90
} else = ".password_max_age" {
	pwPolicy.password_max_age > 90
} else = "" {
	not pwPolicy.pw_max_age
	not pwPolicy.password_max_age
} else = "none" {
	true
}
