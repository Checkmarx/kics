package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.iam_password_policy"].publicly_accessible)
	policyBody := task["community.aws.iam_password_policy"]
	object.get(policyBody, "require_lowercase", "undefined") == "undefined"
	policyName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_lowercase' set and true", [policyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_lowercase' undefined", [policyName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.iam_password_policy"].publicly_accessible)
	policyBody := task["community.aws.iam_password_policy"]
	checkFalse(policyBody.require_lowercase)
	policyName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase is true", [policyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase is false", [policyName]),
	}
}

checkFalse(lowercase) {
	lower(lowercase) == "no"
} else {
	lower(lowercase) == "false"
} else {
	lowercase == false
}