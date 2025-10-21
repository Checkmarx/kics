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
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should set 'log_min_error_statement' to 'ERROR' or a higher severity", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' sets 'log_min_error_statement' to '%s'", [name, results.value]),
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
  resource.settings.database_flags[x].name  == "log_min_error_statement"
  not common_lib.inArray(["ERROR", "LOG", "FATAL", "PANIC"], resource.settings.database_flags[x].value)

  results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags[%d].name", [name, x]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", x, "name"], []),
		"value" : resource.settings.database_flags[x].value
	}
} else = results {
  resource.settings.database_flags.name  == "log_min_error_statement"
  not common_lib.inArray(["ERROR", "LOG", "FATAL", "PANIC"], resource.settings.database_flags.value)

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags.name", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", "name"], []),
		"value" : resource.settings.database_flags.value
	}
}
