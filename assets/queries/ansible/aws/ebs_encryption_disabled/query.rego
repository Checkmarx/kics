package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	ansLib.isAnsibleFalse(task["amazon.aws.ec2_vol"].encrypted)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_vol}}.encrypted", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AWS EBS encryption should be enabled",
		"keyActualValue": "AWS EBS encryption is disabled",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	object.get(task["amazon.aws.ec2_vol"], "encrypted", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_vol}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "AWS EBS encryption should be defined",
		"keyActualValue": "AWS EBS encryption is undefined",
	}
}
