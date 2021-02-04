package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t][k]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)

	settings := instance.settings
	ip_configuration := settings.ip_configuration

	ansLib.isAnsibleFalse(ip_configuration.require_ssl)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.require_ssl", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is true",
		"keyActualValue": "cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t][k]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)

	settings := instance.settings
	ip_configuration := settings.ip_configuration

	object.get(ip_configuration, "require_ssl", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is defined",
		"keyActualValue": "cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is undefined",
	}
}
