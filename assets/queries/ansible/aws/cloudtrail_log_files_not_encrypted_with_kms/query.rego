package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	not common_lib.valid_key(cloudtrail, "kms_key_id")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudtrail.kms_key_id should be set",
		"keyActualValue": "cloudtrail.kms_key_id is undefined",
	}
}
