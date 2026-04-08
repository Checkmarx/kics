package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]

	contains(resource.database_version, "SQLSERVER")
	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should set 'user options' to '0'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' sets 'user options' to '%s'", [name, results.value]),
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results { # array
	resource.settings.database_flags[x].name == "user options"
	resource.settings.database_flags[x].value != "0"

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags[%d].name", [name, x]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", x, "name"], []),
		"value" : resource.settings.database_flags[x].value
	}
} else = results { # single object
	resource.settings.database_flags.name == "user options"
	resource.settings.database_flags.value != "0"

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags.name", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", "name"], []),
		"value" : resource.settings.database_flags.value
	}
}
