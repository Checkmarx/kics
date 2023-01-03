package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	not common_lib.valid_key(settings, "ipConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ipConfiguration' should be defined and not null",
		"keyActualValue": "'settings.ipConfiguration' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	not common_lib.valid_key(settings.ipConfiguration, "requireSsl")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.ipConfiguration", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ipConfiguration.requireSsl' should be defined and not null",
		"keyActualValue": "'settings.ipConfiguration.requireSsl' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "ipConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	settings.ipConfiguration.requireSsl == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.ipConfiguration.requireSsl", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.ipConfiguration.requireSsl' should be true",
		"keyActualValue": "'settings.ipConfiguration.requireSsl' is false",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "ipConfiguration", "requireSsl"], []),
	}
}
