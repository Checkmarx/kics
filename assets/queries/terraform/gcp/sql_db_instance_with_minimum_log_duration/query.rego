package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]

	contains(resource.database_version, "POSTGRES")
	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	resource.settings.database_flags[x].name == "log_min_duration_statement"
	resource.settings.database_flags[x].value != "-1"

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags[%d].name", [name, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should set 'log_min_duration_statement' to '-1'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' sets 'log_min_duration_statement' to '%s'", [name, resource.settings.database_flags[x].value]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", x, "name"], [])
	}
}

has_flag(database_flags) {
	database_flags[_].name == "log_min_duration_statement"
}
