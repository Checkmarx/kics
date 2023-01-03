package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.efs", "efs"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	efs := task[modules[m]]
	ansLib.checkState(efs)

	not common_lib.valid_key(efs, "kms_key_id")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "efs.kms_key_id should be set",
		"keyActualValue": "efs.kms_key_id is undefined",
	}
}
