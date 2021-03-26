package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"community.aws.cloudwatchlogs_log_group", "cloudwatchlogs_log_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs_log_group := task[modules[m]]
	ansLib.checkState(cloudwatchlogs_log_group)

	object.get(cloudwatchlogs_log_group, "retention", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudwatchlogs_log_group.retention is set",
		"keyActualValue": "cloudwatchlogs_log_group.retention is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs_log_group := task[modules[m]]
	ansLib.checkState(cloudwatchlogs_log_group)
	value := cloudwatchlogs_log_group.retention

	validValues = [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]

	not commonLib.inArray(validValues, value)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.retention", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudwatchlogs_log_group.retention is set and valid",
		"keyActualValue": "cloudwatchlogs_log_group.retention is set and invalid",
	}
}
