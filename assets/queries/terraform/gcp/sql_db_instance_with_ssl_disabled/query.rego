package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings

	not common_lib.valid_key(settings, "ip_configuration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration' should be defined and not null",
		"keyActualValue": "'settings.ip_configuration' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings"]),
		"remediation": "ip_configuration {\n\t\trequire_ssl = true\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	ip_configuration := settings.ip_configuration

	not common_lib.valid_key(ip_configuration, "require_ssl")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' should be defined and not null",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "ip_configuration"]),
		"remediation": "require_ssl = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings

	settings.ip_configuration.require_ssl == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.require_ssl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' should be true",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is false",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "ip_configuration", "require_ssl"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
