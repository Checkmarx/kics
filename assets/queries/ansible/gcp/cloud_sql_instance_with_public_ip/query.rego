package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t][k]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	contains(instance.database_version, "SQLSERVER")

	settings := instance.settings
	ip_configuration := settings.ip_configuration

	ansLib.isAnsibleTrue(ip_configuration.ipv4_enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloud_gcp_sql_instance.settings.ip_configuration.ipv4_enabled is disabled",
		"keyActualValue": "cloud_gcp_sql_instance.settings.ip_configuration.ipv4_enabled is enabled",
	}
}
