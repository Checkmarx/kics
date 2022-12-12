package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_sql_instance", "gcp_sql_instance"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	ansLib.check_database_flags_content(instance.settings.database_flags, "log_temp_files", 0)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.settings.database_flags", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_sql_instance.settings.database_flags should set the log_temp_files to 0",
		"keyActualValue": "gcp_sql_instance.settings.database_flags doesn't set the log_temp_files to 0",
	}
}
