package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings.ip_configuration

	count(ip_configuration.dynamic.authorized_networks) > 0

	authorized_network = ip_configuration.dynamic.authorized_networks[id]

	authorized_network.value == "0.0.0.0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.dynamic.authorized_networks.%s.value", [name, id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'authorized_network' address is trusted",
		"keyActualValue": "'authorized_network' address is not restricted: '0.0.0.0'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings.ip_configuration

	not ip_configuration.dynamic.authorized_networks

	ip_configuration.ipv4_enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ipv4_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ipv4_enabled' is disabled and 'private_network' is defined when there are no authorized networks",
		"keyActualValue": "'ipv4_enabled' is enabled when there are no authorized networks",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings.ip_configuration

	not ip_configuration.dynamic.authorized_networks

	not ip_configuration.ipv4_enabled
	not ip_configuration.private_network

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ipv4_enabled' is disabled and 'privatenetwork' is defined when there are no authorized networks",
		"keyActualValue": "'private_network' is not defined when there are no authorized networks",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	settings := resource.settings

	not settings.ip_configuration

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ip_configuration' is defined and allow only trusted networks",
		"keyActualValue": "'ip_configuration' is not defined",
	}
}
