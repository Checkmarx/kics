package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

allowed_ssl_modes := ["ENCRYPTED_ONLY", "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"]

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

	not common_lib.valid_key(ip_configuration, "ssl_mode")
	not common_lib.valid_key(ip_configuration, "require_ssl")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration.ssl_mode' should be defined and not null",
		"keyActualValue": "'settings.ip_configuration.ssl_mode' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "ip_configuration"]),
		"remediation": "ssl_mode = TRUSTED_CLIENT_CERTIFICATE_REQUIRED",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings

	not common_lib.inArray(allowed_ssl_modes, settings.ip_configuration.ssl_mode)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.ip_configuration.ssl_mode' should be set to 'ENCRYPTED_ONLY' or 'TRUSTED_CLIENT_CERTIFICATE_REQUIRED'",
		"keyActualValue": sprintf("'settings.ip_configuration.ssl_mode' is set to '%s'", [settings.ip_configuration.ssl_mode]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "ip_configuration", "ssl_mode"]),
		"remediation": json.marshal({
			"before": settings.ip_configuration.ssl_mode,
			"after": "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {																			# legacy support (terraform version < 6.0.1)
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
