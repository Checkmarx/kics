package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}

	object.get(task[modules[index]], "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.kms_key_id is set", [modules[index]]),
		"keyActualValue": sprintf("%s.kms_key_id is undefined", [modules[index]]),
	}
}
