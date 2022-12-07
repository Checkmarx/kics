package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	not common_lib.valid_key(settings, "backupConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.backupConfiguration' should be defined and not null",
		"keyActualValue": "'settings.backupConfiguration' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	not common_lib.valid_key(settings.backupConfiguration, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.backupConfiguration", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.backupConfiguration.enabled' should be defined and not null",
		"keyActualValue": "'settings.backupConfiguration.enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "backupConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	settings.backupConfiguration.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.backupConfiguration.enabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.backupConfiguration.enabled' should be true",
		"keyActualValue": "'settings.backupConfiguration.enabled' is false",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "backupConfiguration", "enabled"], []),
	}
}
