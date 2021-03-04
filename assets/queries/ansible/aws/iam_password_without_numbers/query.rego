package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["community.aws.iam_password_policy"]

	object.get(policy, "require_numbers", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_numbers' set and true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_numbers' undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task["community.aws.iam_password_policy"]

	ansLib.isAnsibleFalse(policy.require_numbers)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers is true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers is false", [task.name]),
	}
}
