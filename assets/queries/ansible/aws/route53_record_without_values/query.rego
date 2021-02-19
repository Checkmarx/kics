package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.route53"].publicly_accessible)
	object.get(task["community.aws.route53"], "value", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.route53}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_route53.value is defined",
		"keyActualValue": "aws_route53.value is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.route53"].publicly_accessible)
	valueIsEmpty(task["community.aws.route53"].value)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.route53}}.value", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_route53.value is not empty",
		"keyActualValue": "aws_route53.value is empty",
	}
}

valueIsEmpty(value) {
	value == null
}

valueIsEmpty(value) {
	value != null
	count(value) <= 0
}
