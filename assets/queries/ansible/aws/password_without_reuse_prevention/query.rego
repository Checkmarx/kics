package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.iam_password_policy", "iam_password_policy"}
	pwPolicy := task[modules[m]]
	ansLib.checkState(pwPolicy)

	searchKey := checkPwReusePrevent(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}%s", [task.name, modules[m], searchKey]),
		"issueType": issueType(searchKey),
		"keyExpectedValue": "iam_password_policy should have the property 'password_reuse_prevent' greater than 0",
		"keyActualValue": "iam_password_policy has the property 'password_reuse_prevent' unassigned or assigned to 0",
	}
}

issueType(str) = "MissingAttribute" {
	str == ""
} else = "IncorrectValue" {
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
