package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	pgConfig := task["azure.azcollection.azure_rm_postgresqlconfiguration"]

	is_string(pgConfig.name)
	is_string(pgConfig.value)

	lower(pgConfig.name) == "connection_throttling"
	upper(pgConfig.value) != "ON"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_postgresqlconfiguration}}.value", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "azure.azcollection.azure_rm_postgresqlconfiguration.value should be 'ON' when name is 'connection_throttling'",
		"keyActualValue": "azure.azcollection.azure_rm_postgresqlconfiguration.value if 'OFF'",
	}
}
