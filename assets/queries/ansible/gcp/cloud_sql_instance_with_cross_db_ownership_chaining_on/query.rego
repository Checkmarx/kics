package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_sql_instance", "gcp_sql_instance"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	contains(instance.database_version, "SQLSERVER")
	ansLib.check_database_flags_content(instance.settings.database_flags, "cross db ownership chaining", "off")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.settings.database_flags", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{cloud_gcp_sql_instance}}.settings.database_flags should be correct",
		"keyActualValue": "{{cloud_gcp_sql_instance}}.settings.database_flags.name is 'cross db ownership chaining' and cloud_gcp_sql_instance.settings.database_flags.value is not 'off'",
	}
}
