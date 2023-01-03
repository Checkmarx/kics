package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kms := task["community.aws.aws_kms"]
	ansLib.checkState(kms)

	kms.enabled == false

	result := {
		"documentId": id,
		"resourceType": "community.aws.aws_kms",
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_kms}}.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.aws_kms.enabled should be set to true",
		"keyActualValue": "community.aws.aws_kms.enabled is set to false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kms := task["community.aws.aws_kms"]
	ansLib.checkState(kms)

	kms.pending_window

	result := {
		"documentId": id,
		"resourceType": "community.aws.aws_kms",
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_kms}}.pending_window", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.aws_kms.pending_window should be undefined",
		"keyActualValue": "community.aws.aws_kms.pending_windowis is set",
	}
}
