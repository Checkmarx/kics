package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_sql_instance"]
	ansLib.checkState(instance)

	ansLib.isAnsibleFalse(instance.settings.ip_configuration.require_ssl)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.require_ssl", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{cloud_gcp_sql_instance}}.settings.ip_configuration.require_ssl is true",
		"keyActualValue": "{{cloud_gcp_sql_instance}}.settings.ip_configuration.require_ssl is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_sql_instance"]
	ansLib.checkState(instance)

	object.get(instance.settings.ip_configuration, "require_ssl", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{cloud_gcp_sql_instance}}.settings.ip_configuration.require_ssl is defined",
		"keyActualValue": "{{cloud_gcp_sql_instance}}.settings.ip_configuration.require_ssl is undefined",
	}
}
