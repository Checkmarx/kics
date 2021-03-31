package Cx

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings

	object.get(settings, "ip_configuration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration' is defined",
		"keyActualValue": "'settings.ip_configuration' is undefined",
	}
}

CxPolicy[result] {
	settings := input.document[i].resource.google_sql_database_instance[name].settings
	ip_configuration := settings.ip_configuration

	object.get(ip_configuration, "require_ssl", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' is defined",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is undefined",
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
