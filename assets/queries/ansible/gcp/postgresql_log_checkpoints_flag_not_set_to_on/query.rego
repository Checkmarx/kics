package Cx

CxPolicy [result ]  {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	gcp_task := task["google.cloud.gcp_sql_instance"]
	contains(gcp_task.database_version, "POSTGRES")

	IsMissingAttribute(gcp_task)

	result := {
			"documentId": document.id,
			"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}", [task.name]),
			"issueType": "MissingAttribute",
			"keyExpectedValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags is defined",
			"keyActualValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags is not defined"
			}
}

CxPolicy [result ]  {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	gcp_task := task["google.cloud.gcp_sql_instance"]
	contains(gcp_task.database_version, "POSTGRES")

	IsFlagOff(gcp_task.settings.databaseFlags)

	result := {
			"documentId": document.id,
			"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.databaseFlags", [task.name]),
			"issueType": "IncorrectValue",
			"keyExpectedValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags has 'log_checkpoints' flag set to 'on'",
			"keyActualValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags has 'log_checkpoints' flag set to 'off'"
			}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

IsMissingAttribute(gcp_task) {
	object.get(gcp_task, "settings", "undefined") == "undefined"
}

IsMissingAttribute(gcp_task) {
	object.get(gcp_task.settings, "databaseFlags", "undefined") == "undefined"
}

IsFlagOff(dbFlags) {
	dbFlags[j].name == "log_checkpoints"
	lower(dbFlags[j].value) == "off"
}
