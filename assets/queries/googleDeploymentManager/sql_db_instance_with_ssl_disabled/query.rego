package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	not common_lib.valid_key(settings, "ipConfiguration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.ipConfiguration", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ipConfiguration' is undefined and not null",
		"keyActualValue": "'settings.ipConfiguration' is not defined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "ipConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	not common_lib.valid_key(settings.ipConfiguration, "requireSsl")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.ipConfiguration.requireSsl", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'settings.ipConfiguration' is undefined and not null",
		"keyActualValue": "'settings.ipConfiguration' is not defined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "ipConfiguration", "requireSsl"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"
	settings := resource.properties.settings

	settings.ipConfiguration.requireSsl == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.ipConfiguration.requireSsl", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'settings.ip_configuration.require_ssl' to be true",
		"keyActualValue": "'settings.ip_configuration.require_ssl' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "ipConfiguration", "requireSsl"], []),
	}
}
