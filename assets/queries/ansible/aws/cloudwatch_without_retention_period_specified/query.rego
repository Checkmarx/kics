package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.cloudwatchlogs_log_group"], "retention", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudwatchlogs_log_group}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.cloudwatchlogs_log_group.retention is set",
		"keyActualValue": "community.aws.cloudwatchlogs_log_group.retention is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	value := task["community.aws.cloudwatchlogs_log_group"].retention

	validValues = [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]

	count({x | validValues[x]; validValues[x] == value}) == 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudwatchlogs_log_group}}.retention", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.cloudwatchlogs_log_group.retention is set and valid",
		"keyActualValue": "community.aws.cloudwatchlogs_log_group.retention is set and invalid",
	}
}
