package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	gcp_task := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(gcp_task)
	contains(gcp_task.database_version, "POSTGRES")
	ansLib.IsMissingAttribute(gcp_task)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags is defined",
		"keyActualValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags is not defined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	gcp_task := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(gcp_task)
	contains(gcp_task.database_version, "POSTGRES")
	ansLib.check_database_flags_content(gcp_task.settings.databaseFlags, "log_connections", "on")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.databaseFlags", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags has 'log_connections' flag set to 'on'",
		"keyActualValue": "{{google.cloud.gcp_sql_instance}}.settings.databaseFlags has 'log_connections' flag set to 'off'",
	}
}
