package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.route53"], "value", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.route53}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_route53.value is defined",
		"keyActualValue": "aws_route53.value is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ansLib.checkValue(task["community.aws.route53"].value)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.route53}}.value", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_route53.value is not empty",
		"keyActualValue": "aws_route53.value is empty",
	}
}
