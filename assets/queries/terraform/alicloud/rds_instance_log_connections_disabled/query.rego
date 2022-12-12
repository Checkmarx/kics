package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name].parameters
    resource[parameter].name == "log_connections"
    resource[parameter].value == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s].parameters[%d].value", [name, parameter]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'log_connections' parameter value should be 'ON'",
		"keyActualValue": "'log_connections' parameter value is 'OFF'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "parameters", parameter, "value"], []),
		"remediation": json.marshal({
			"before": "OFF",
			"after": "ON"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	common_lib.valid_key(resource, "parameters")
	not has_log_conn(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s].parameters", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'log_connections' parameter should be defined and value should be 'ON'",
		"keyActualValue": "'log_connections' parameter is not defined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], ["parameters"]),
	}
}

has_log_conn(resource){
	parameter := resource.parameters[j]
	parameter.name == "log_connections"
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	not common_lib.valid_key(resource, "parameters")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'log_connections' parameter should be defined and value should be 'ON' in parameters array",
		"keyActualValue": "'log_connections' parameter is not defined in parameters array",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
		"remediation": "parameters = [{\n\t\tname = \"log_connections\"\n\t\tvalue = \"ON\"\n\t}]",
		"remediationType": "addition",
	}
}
