package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudwatchlogs_log_group"].publicly_accessible)
	cloudwatchlogs := task["community.aws.cloudwatchlogs_log_group"]

	not cloudwatchlogs.retention

	result := {
		"documentId": document.id,
		"searchKey": sprintf("{{community.aws.cloudwatchlogs_log_group}}.name=%s", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'retention_in_days' is set",
		"keyActualValue": "'retention_in_days' is not set",
	}
}
