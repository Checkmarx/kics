package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kms := task["community.aws.aws_kms"]
	ansLib.checkState(kms)

	kms.enabled == true
	object.get(kms, "pending_window", "undefined") == "undefined"
	object.get(kms, "enable_key_rotation", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_kms}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.aws_kms.enable_key_rotation is set",
		"keyActualValue": "community.aws.aws_kms.enable_key_rotation is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kms := task["community.aws.aws_kms"]
	ansLib.checkState(kms)

	kms.enabled == true
	object.get(kms, "pending_window", "undefined") == "undefined"
	kms.enable_key_rotation == false

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_kms}}.enable_key_rotation", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.aws_kms.enable_key_rotation is set to true",
		"keyActualValue": "community.aws.aws_kms.enable_key_rotation is set to false",
	}
}
