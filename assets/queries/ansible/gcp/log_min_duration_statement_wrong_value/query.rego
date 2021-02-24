package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	database_flags := instance.settings.database_flags
	ansLib.check_database_flags_content(database_flags, "log_min_duration_statement", -1)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags sets the log_min_duration_statement to -1", [task.name]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags doesn't set the log_min_duration_statement to -1", [task.name]),
	}
}
