package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	pwPolicy := task["community.aws.iam_password_policy"]

	searchKey := checkPwReusePrevent(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}%s", [task.name, searchKey]),
		"issueType": issueType(searchKey),
		"keyExpectedValue": "community.aws.iam_password_policy should have the property 'password_reuse_prevent' greater than 0",
		"keyActualValue": "community.aws.iam_password_policy has the property 'password_reuse_prevent' unassigned or assigned to 0",
	}
}

issueType(str) = "MissingAttribute" {
	str == ""
} else = "WrongValue" {
	true
}

checkPwReusePrevent(pwPolicy) = ".password_reuse_prevent" {
	pwPolicy.password_reuse_prevent == 0
} else = ".pw_reuse_prevent" {
	pwPolicy.pw_reuse_prevent == 0
} else = ".prevent_reuse" {
	pwPolicy.prevent_reuse == 0
} else = "" {
	not pwPolicy.password_reuse_prevent
	not pwPolicy.pw_reuse_prevent
	not pwPolicy.prevent_reuse
} else = "none" {
	true
}
