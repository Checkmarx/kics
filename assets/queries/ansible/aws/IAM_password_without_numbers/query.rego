package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	policyBody := task["community.aws.iam_password_policy"]
	object.get(policyBody, "require_numbers", "undefined") == "undefined"
	policyName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_numbers' set and true", [policyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_numbers' undefined", [policyName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	policyBody := task["community.aws.iam_password_policy"]
	checkFalse(policyBody.require_numbers)
	policyName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers is true", [policyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_numbers is false", [policyName]),
	}
}

checkFalse(require_numbers) {
	lower(require_numbers) == "no"
} else {
	lower(require_numbers) == "false"
} else {
	require_numbers == false
}
