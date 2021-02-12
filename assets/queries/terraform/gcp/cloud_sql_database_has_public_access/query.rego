package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings.ip_configuration

	count(ip_configuration.authorized_networks) > 0

	authorized_network = getAuthorizedNetworks(ip_configuration.authorized_networks)

	contains(authorized_network[j].value, "0.0.0.0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.authorized_networks.value=%s", [name, authorized_network[j].value]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'authorized_network' address is trusted",
		"keyActualValue": "'authorized_network' address is not restricted: '0.0.0.0/0'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings.ip_configuration

	object.get(ip_configuration,"authorized_networks","undefined") == "undefined"

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

    object.get(ip_configuration,"authorized_networks","undefined") == "undefined"

	not ip_configuration.ipv4_enabled
	object.get(ip_configuration,"private_network","undefined") == "undefined"

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

	object.get(settings,"ip_configuration","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ip_configuration' is defined and allow only trusted networks",
		"keyActualValue": "'ip_configuration' is not defined",
	}
}

getAuthorizedNetworks(networks) = list {
    is_array(networks)
    list := networks
} else = list {
    is_object(networks)
    list := [networks]
} else = null

