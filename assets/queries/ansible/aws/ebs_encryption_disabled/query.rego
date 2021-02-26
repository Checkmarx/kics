package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ansLib.isAnsibleFalse(task["amazon.aws.ec2_vol"].encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_vol}}.encrypted", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AWS EBS encryption should be enabled",
		"keyActualValue": "AWS EBS encryption is disabled",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["amazon.aws.ec2_vol"], "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_vol}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "AWS EBS encryption should be defined",
		"keyActualValue": "AWS EBS encryption is undefined",
	}
}
