package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	firstPolicy = tasks[_]
    ansLib.isAnsibleTrue(task["community.aws.iam_password_policy"].publicly_accessible)
	policyBody = firstPolicy["community.aws.iam_password_policy"]
	policyName = firstPolicy.name

	not getName(policyBody)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}", [policyName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'min_pw_length/minimum_password_length' is set and no less than 8",
		"keyActualValue": "'min_pw_length/minimum_password_length' is undefined",
	}
}

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	firstPolicy = tasks[_]
    ansLib.isAnsibleTrue(task["community.aws.iam_password_policy"].publicly_accessible)
	policyBody = firstPolicy["community.aws.iam_password_policy"]
	policyName = firstPolicy.name

	variableName = getName(policyBody)
	to_number(policyBody[variableName]) < 8

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_password_policy}}.{{min_pw_length}}", [policyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is set and no less than 8", [variableName]),
		"keyActualValue": sprintf("'%s' is less than 8", [variableName]),
	}
}

getName(policyBody) = "min_pw_length" {
	object.get(policyBody, "min_pw_length", "undefined") != "undefined"
} else = "minimum_password_length" {
	object.get(policyBody, "minimum_password_length", "undefined") != "undefined"
} else = false {
	true
}