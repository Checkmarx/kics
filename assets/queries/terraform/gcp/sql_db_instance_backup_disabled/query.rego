package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	not common_lib.valid_key(settings, "backup_configuration")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration should be defined and not null",
		"keyActualValue": "settings.backup_configuration is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings"]),
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings.backup_configuration
	not common_lib.valid_key(settings, "enabled")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration.enabled should be defined and not null",
		"keyActualValue": "settings.backup_configuration.enabled is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "backup_configuration"]),
		"remediation": "enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	settings.backup_configuration.enabled == false
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "settings.backup_configuration.enabled should be true",
		"keyActualValue": "settings.backup_configuration.enabled is false",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "backup_configuration", "enabled"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
