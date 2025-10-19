package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]

	contains(resource.database_version, "MYSQL")
	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "settings")

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be set 'skip_show_database' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name], []),
		"remediation": null,
		"remediationType": null
	}
} else = results {
	not common_lib.valid_key(resource.settings, "database_flags")

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be set 'skip_show_database' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings"], []),
		"remediation": null,
		"remediationType": null
	}

} else = results {
	not has_flag(resource.settings.database_flags)

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be set 'skip_show_database' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' does not set 'skip_show_database'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags"], []),
		"remediation": "database_flags {name = \"skip_show_database\", value = \"on\"}",
		"remediationType": "addition"
	}

} else = results {
	resource.settings.database_flags[x].name == "skip_show_database"
	resource.settings.database_flags[x].value != "on"

	results := {
		"searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags[%s]", [name, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' should be set 'skip_show_database' to 'on'", [name]),
		"keyActualValue": sprintf("'google_sql_database_instance[%s].settings.database_flags' sets 'skip_show_database' to '%s'", [name, resource.settings.database_flags[x].value]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "database_flags", x], []),
		"remediation": json.marshal({
			"before": sprintf("%s",[resource.settings.database_flags[x].value]),
			"after": "on"
		}),
		"remediationType": "replacement"
	}
}

has_flag(database_flags) {
	database_flags[_].name == "skip_show_database"
}
