package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.cloudformation", "cloudformation"}
	cloudformation := task[modules[m]]
	ansLib.checkState(cloudformation)

	object.get(cloudformation, "notification_arns", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudformation.notification_arns is set",
		"keyActualValue": "cloudformation.notification_arns is undefined",
	}
}
