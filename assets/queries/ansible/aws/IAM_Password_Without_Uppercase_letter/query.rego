package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.iam_password_policy"].publicly_accessible)
	policyBody := task["community.aws.iam_password_policy"]
	object.get(policyBody, "require_uppercase", "undefined") == "undefined"
	policyName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_uppercase' set and true", [policyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_uppercase' undefined", [policyName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.iam_password_policy"].publicly_accessible)
	policyBody := task["community.aws.iam_password_policy"]
	checkFalse(policyBody.require_uppercase)
	policyName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase is true", [policyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_uppercase is false", [policyName]),
	}
}

checkFalse(uppercase) {
	lower(uppercase) == "no"
} else {
	lower(uppercase) == "false"
} else {
	uppercase == false
}