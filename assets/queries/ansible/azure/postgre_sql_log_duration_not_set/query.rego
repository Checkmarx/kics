package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_postgresqlconfiguration", "azure_rm_postgresqlconfiguration"}
	pgConfig := task[modules[m]]
	ansLib.checkState(pgConfig)

	is_string(pgConfig.name)
	is_string(pgConfig.value)

	lower(pgConfig.name) == "log_duration"
	upper(pgConfig.value) != "ON"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.value", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_postgresqlconfiguration.value should be 'ON' for 'log_duration'",
		"keyActualValue": "azure_rm_postgresqlconfiguration.value is 'OFF' for 'log_duration'",
	}
}
