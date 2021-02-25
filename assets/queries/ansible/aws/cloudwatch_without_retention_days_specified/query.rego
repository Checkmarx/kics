package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task["community.aws.cloudwatchlogs_log_group"]

	not cloudwatchlogs.retention

	result := {
		"documentId": id,
		"searchKey": sprintf("{{community.aws.cloudwatchlogs_log_group}}.name=%s", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'retention_in_days' is set",
		"keyActualValue": "'retention_in_days' is not set",
	}
}
