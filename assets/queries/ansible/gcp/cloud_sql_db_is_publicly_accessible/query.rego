package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	ip_configuration := instance.settings.ip_configuration
	count(ip_configuration.authorized_networks) > 0
	authorized_network := ip_configuration.authorized_networks[_]
	authorized_network.value == "0.0.0.0"
	network := authorized_network.name

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.authorized_networks.name=%s.value", [task.name, network]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.authorized_networks.name=%s.value address is trusted", [task.name, network]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.authorized_networks.name=%s.value address is not restricted: '0.0.0.0'", [task.name, network]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	ip_configuration := instance.settings.ip_configuration
	object.get(ip_configuration, "authorized_networks", "undefined") == "undefined"
	ansLib.isAnsibleTrue(ip_configuration.ipv4_enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled is disabled when there are no authorized networks", [task.name]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled is enabled when there are no authorized networks", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	object.get(instance.settings, "ip_configuration", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration is defined and allow only trusted networks", [task.name]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration is undefined", [task.name]),
	}
}
