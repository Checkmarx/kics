package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_db_instance[name]
	not common_lib.valid_key(resource, "sql_collector_status")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'sql_collector_status' should be defined and set to Enabled and 'sql_collector_config_value' should be defined and set to 180 or more",
		"keyActualValue": "'sql_collector_status' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.sql_collector_status == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].sql_collector_status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sql_collector_status' should be defined and set to Enabled and 'sql_collector_config_value' should be defined and set to 180 or more",
		"keyActualValue": "'sql_collector_status' is set to 'Disabled'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name,"sql_collector_status" ], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_db_instance[name]
	not common_lib.valid_key(resource, "sql_collector_config_value")


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'sql_collector_status' should be defined and set to Enabled and 'sql_collector_config_value' should be defined and set to 180 or more",
		"keyActualValue": "'sql_collector_config_value' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.sql_collector_config_value == 30

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].sql_collector_config_value", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sql_collector_status' should be defined and set to Enabled and 'sql_collector_config_value' should be defined and set to 180 or more",
		"keyActualValue": "'sql_collector_config_value' is set to 30",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name,"sql_collector_config_value" ], []),
	}
}
