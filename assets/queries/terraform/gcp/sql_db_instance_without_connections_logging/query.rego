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
	not common_lib.valid_key(resource, "settings")
	not common_lib.valid_key(resource, "clone")

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be defined and set 'log_connections' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name], [])
	}
} else = results {
	common_lib.valid_key(resource, "settings")
	not common_lib.valid_key(resource.settings, "database_flags")

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be defined and set 'log_connections' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings"], [])
	}

} else = results {
	common_lib.valid_key(resource, "settings")
	not has_flag(resource.settings.database_flags)

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be defined and set 'log_connections' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' does not set 'log_connections'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags"], [])
	}

} else = results {  # array
	common_lib.valid_key(resource, "settings")
	resource.settings.database_flags[x].name == "log_connections"
	resource.settings.database_flags[x].value != "on"

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags[%d].name", [name, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be defined and set 'log_connections' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' sets 'log_connections' to '%s'", [name, resource.settings.database_flags[x].value]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", x, "name"], [])
	}
} else = results { # single object
	common_lib.valid_key(resource, "settings")
	resource.settings.database_flags.name == "log_connections"
	resource.settings.database_flags.value != "on"

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be defined and set 'log_connections' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' sets 'log_connections' to '%s'", [name, resource.settings.database_flags.value]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", "name"], [])
	}
}

has_flag(database_flags) {
	database_flags[_].name == "log_connections"
} else {
	database_flags.name    == "log_connections"
}
