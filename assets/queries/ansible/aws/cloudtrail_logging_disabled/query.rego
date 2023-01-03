package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	ansLib.isAnsibleFalse(cloudtrail.enable_logging)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_logging", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudtrail.enable_logging should be true",
		"keyActualValue": "cloudtrail.enable_logging is false",
	}
}
