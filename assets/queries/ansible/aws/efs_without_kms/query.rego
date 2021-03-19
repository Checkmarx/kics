package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.efs", "efs"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	efs := task[modules[m]]
	ansLib.checkState(efs)

	object.get(efs, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "efs.kms_key_id is set",
		"keyActualValue": "efs.kms_key_id is undefined",
	}
}
