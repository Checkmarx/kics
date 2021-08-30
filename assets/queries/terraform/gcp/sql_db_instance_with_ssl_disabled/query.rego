package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings

	not common_lib.valid_key(settings, "ip_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration' is defined and not null",
		"keyActualValue": "'settings.ip_configuration' is undefined or null",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	ip_configuration := settings.ip_configuration

	not common_lib.valid_key(ip_configuration, "require_ssl")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' is defined and not null",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is undefined or null",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings

	settings.ip_configuration.require_ssl == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.require_ssl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' is true",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is false",
	}
}
