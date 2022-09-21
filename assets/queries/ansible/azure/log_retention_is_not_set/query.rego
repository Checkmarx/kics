package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_postgresqlconfiguration", "azure_rm_postgresqlconfiguration"}
	postgresql_configuration := task[modules[m]]
	ansLib.checkState(postgresql_configuration)

	is_string(postgresql_configuration.name)
	lower(postgresql_configuration.name) == "log_retention"

	is_string(postgresql_configuration.value)
	lower(postgresql_configuration.value) != "on"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.value", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_postgresqlconfiguration.value should equal to 'on'",
		"keyActualValue": "azure_rm_postgresqlconfiguration.value is not equal to 'on'",
	}
}
