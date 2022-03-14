package Cx

import data.generic.common as common_lib

incorrect_values := {"Close"}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.ssl_action == incorrect_values[val]


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].ssl_action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ssl_action' value should be 'Open'",
		"keyActualValue": sprintf("'ssl_action' value is '%s'", [val]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "ssl_action"], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	not common_lib.valid_key(resource, "ssl_action")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s]]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ssl_action' value should be 'Open'",
		"keyActualValue": "'ssl_action' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
	}
}
