package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	not common_lib.valid_key(settings, "backup_configuration")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration is defined and not null",
		"keyActualValue": "settings.backup_configuration is undefined or null",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings.backup_configuration
	not common_lib.valid_key(settings, "enabled")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration.enabled is defined and not null",
		"keyActualValue": "settings.backup_configuration.enabled is undefined or null",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	settings.backup_configuration.enabled == false
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "settings.backup_configuration.enabled is true",
		"keyActualValue": "settings.backup_configuration.enabled is false",
	}
}
