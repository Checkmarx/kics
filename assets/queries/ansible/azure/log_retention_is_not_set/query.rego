package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	postgresql_configuration := task.azure_rm_postgresqlconfiguration

	is_string(postgresql_configuration.name)
	lower(postgresql_configuration.name) == "log_retention"

	is_string(postgresql_configuration.value)
	lower(postgresql_configuration.value) != "on"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_postgresqlconfiguration}}.value", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'value' is equal to 'on'",
		"keyActualValue": "'value' is not equal to 'on'",
	}
}
