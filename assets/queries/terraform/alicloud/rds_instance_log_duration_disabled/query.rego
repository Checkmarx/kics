package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name].parameters
    resource[parameter].name == "log_duration"
    resource[parameter].value == "OFF"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].parameters[%d].value", [name, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'log_duration' parameter value should be 'ON'",
		"keyActualValue": "'log_duration' parameter value is 'OFF'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "parameters", parameter, "value"], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	not has_log_disconn(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s]]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'log_duration' parameter is defined and value should be 'ON'",
		"keyActualValue": "'log_duration' parameter is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
	}
}

has_log_disconn(resource){
	parameter := resource.parameters[j]
	parameter.name == "log_duration"
}
