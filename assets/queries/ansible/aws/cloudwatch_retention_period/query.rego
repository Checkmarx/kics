package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudwatchlogs_log_group"].publicly_accessible)
	object.get(task["community.aws.cloudwatchlogs_log_group"], "retention", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudwatchlogs_log_group}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.cloudwatchlogs_log_group.retention is set",
		"keyActualValue": "community.aws.cloudwatchlogs_log_group.retention is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudwatchlogs_log_group"].publicly_accessible)
	value := task["community.aws.cloudwatchlogs_log_group"].retention

	validValues = [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]

	count({x | validValues[x]; validValues[x] == value}) == 0

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudwatchlogs_log_group}}.retention", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.cloudwatchlogs_log_group.retention is set and valid",
		"keyActualValue": "community.aws.cloudwatchlogs_log_group.retention is set and invalid",
	}
}