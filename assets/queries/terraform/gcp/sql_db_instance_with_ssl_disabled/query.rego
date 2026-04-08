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
		"remediation": sprintf("ip_configuration {\n\t\tssl_mode = %s\n\t}\n", [get_remediation(input.document[i].resource.google_sql_database_instance[name].database_version)]),
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
		"remediation": sprintf("ssl_mode = %s", [get_remediation(input.document[i].resource.google_sql_database_instance[name].database_version)]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	settings := resource.settings

	database_version := input.document[i].resource.google_sql_database_instance[name].database_version
	kev := get_expected_key(database_version, settings.ip_configuration.ssl_mode)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'settings.ip_configuration.ssl_mode' should be set to %s", [kev]),
		"keyActualValue": sprintf("'settings.ip_configuration.ssl_mode' is set to '%s'", [settings.ip_configuration.ssl_mode]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "ip_configuration", "ssl_mode"]),
		"remediation": json.marshal({
			"before": settings.ip_configuration.ssl_mode,
			"after": get_remediation(database_version)
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

get_expected_key(database_version, ssl_mode) = "'ENCRYPTED_ONLY'" {
	contains(database_version, "SQLSERVER")
	ssl_mode == "ENCRYPTED_ONLY"
} else = "'ENCRYPTED_ONLY' or 'TRUSTED_CLIENT_CERTIFICATE_REQUIRED'" {
	not common_lib.inArray(allowed_ssl_modes, ssl_mode)
}

get_remediation(database_version) = "ENCRYPTED_ONLY" {
	contains(database_version, "SQLSERVER")
} else = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"