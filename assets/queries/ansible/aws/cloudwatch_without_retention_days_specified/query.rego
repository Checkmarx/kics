package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
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

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
