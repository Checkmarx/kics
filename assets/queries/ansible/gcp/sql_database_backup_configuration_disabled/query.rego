package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	path := getPathDefinitions(instance)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}%s", [task.name, path.defined]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' is defined", [path.undefined]),
		"keyActualValue": sprintf("'%s' is undefined", [path.undefined]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_sql_instance"]

	ansLib.checkState(instance)
	not ansLib.isAnsibleTrue(instance.settings.backup_configuration.enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.backup_configuration.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.backup_configuration.require_ssl' is true",
		"keyActualValue": "'settings.backup_configuration.require_ssl' is false",
	}
}

getPathDefinitions(instance) = result {
	object.get(instance, "settings", "undefined") == "undefined"
	result = {"defined": "", "undefined": "settings"}
}

getPathDefinitions(instance) = result {
	object.get(instance.settings, "backup_configuration", "undefined") == "undefined"
	result = {"defined": ".settings", "undefined": "settings.backup_configuration"}
}

getPathDefinitions(instance) = result {
	object.get(instance.settings.backup_configuration, "enabled", "undefined") == "undefined"
	result = {"defined": ".settings.backup_configuration", "undefined": "settings.backup_configuration.enabled"}
}
