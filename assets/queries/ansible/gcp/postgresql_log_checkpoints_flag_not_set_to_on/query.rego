package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_sql_instance", "gcp_sql_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcp_task := task[modules[m]]
	ansLib.checkState(gcp_task)

	contains(gcp_task.database_version, "POSTGRES")
	IsMissingAttribute(gcp_task)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_sql_instance.settings.databaseFlags is defined",
		"keyActualValue": "gcp_sql_instance.settings.databaseFlags is not defined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcp_task := task[modules[m]]
	ansLib.checkState(gcp_task)

	contains(gcp_task.database_version, "POSTGRES")
	ansLib.check_database_flags_content(gcp_task.settings.databaseFlags, "log_checkpoints", "on")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.settings.databaseFlags", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_sql_instance.settings.databaseFlags has 'log_checkpoints' flag set to 'on'",
		"keyActualValue": "gcp_sql_instance.settings.databaseFlags has 'log_checkpoints' flag set to 'off'",
	}
}

IsMissingAttribute(task) {
	object.get(task, "settings", "undefined") == "undefined"
}

IsMissingAttribute(task) {
	object.get(task.settings, "databaseFlags", "undefined") == "undefined"
}
