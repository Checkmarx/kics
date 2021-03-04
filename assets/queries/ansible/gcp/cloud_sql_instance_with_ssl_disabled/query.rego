package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sql_instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(sql_instance)
	path := getPathDefinitions(sql_instance)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}%s", [task.name, path.defined]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' is defined", [path.undefined]),
		"keyActualValue": sprintf("'%s' is undefined", [path.undefined]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sql_instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(sql_instance)
	not ansLib.isAnsibleTrue(sql_instance.settings.ip_configuration.require_ssl)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.require_ssl", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' is true",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is false",
	}
}

getPathDefinitions(instance) = result {
	object.get(instance, "settings", "undefined") == "undefined"
	result = {"defined": "", "undefined": "settings"}
}

getPathDefinitions(instance) = result {
	object.get(instance.settings, "ip_configuration", "undefined") == "undefined"
	result = {"defined": ".settings", "undefined": "settings.ip_configuration"}
}

getPathDefinitions(instance) = result {
	object.get(instance.settings.ip_configuration, "require_ssl", "undefined") == "undefined"
	result = {"defined": ".settings.ip_configuration", "undefined": "settings.ip_configuration.require_ssl"}
}
