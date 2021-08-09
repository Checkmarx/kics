package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.cloudformation", "cloudformation"}
	cloudformation := task[modules[m]]
	ansLib.checkState(cloudformation)

	not common_lib.valid_key(cloudformation, "notification_arns")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudformation.notification_arns is set",
		"keyActualValue": "cloudformation.notification_arns is undefined",
	}
}
