package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "sqladmin.v1beta4.instance"

	startswith(resource.properties.databaseVersion, "MYSQL")
	resource.properties.settings.databaseFlags[f].name == "local_infile"
	resource.properties.settings.databaseFlags[f].value == "on"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.settings.databaseFlags[%d]", [resource.name, f]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'settings.databaseFlags[%d]' should be 'off'", [f]),
		"keyActualValue": sprintf("'settings.databaseFlags[%d]' is equal to 'on'", [f]), 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "settings", "databaseFlags", f], []),
	}
}
