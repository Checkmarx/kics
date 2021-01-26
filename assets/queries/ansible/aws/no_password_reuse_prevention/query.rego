package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	pwPolicy := task["community.aws.iam_password_policy"]
	pwPolicyName := task.name

	searchKey := checkPwReusePrevent(pwPolicy)
	searchKey != "none"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}%s", [pwPolicyName, searchKey]),
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

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
