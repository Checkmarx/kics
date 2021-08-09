package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kms := task["community.aws.aws_kms"]
	ansLib.checkState(kms)

	kms.enabled == true
	not common_lib.valid_key(kms, "pending_window")
	not common_lib.valid_key(kms, "enable_key_rotation")

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
	not common_lib.valid_key(kms, "pending_window")
	kms.enable_key_rotation == false

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_kms}}.enable_key_rotation", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.aws_kms.enable_key_rotation is set to true",
		"keyActualValue": "community.aws.aws_kms.enable_key_rotation is set to false",
	}
}
