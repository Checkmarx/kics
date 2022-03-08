package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name].parameters
    resource[parameter].name == "log_connections"
    resource[parameter].value == "OFF"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].parameters[j]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'log_connections' parameter value should be 'ON'",
		"keyActualValue": "'log_connections' parameter value is 'OFF'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "parameters", parameter], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	not has_log_conn(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].parameters[j]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'log_connections' parameter is defined value should be 'ON'",
		"keyActualValue": "'log_connections' parameter is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "parameters"], []),
	}
}

has_log_conn(resource){
	parameter := resource.parameters[j]
	parameter.name == "log_connections"
}

