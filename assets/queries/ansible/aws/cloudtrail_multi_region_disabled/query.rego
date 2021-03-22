package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	ansLib.isAnsibleFalse(cloudtrail.is_multi_region_trail)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.is_multi_region_trail", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudtrail.is_multi_region_trail is true",
		"keyActualValue": "cloudtrail.is_multi_region_trail is false",
	}
}
