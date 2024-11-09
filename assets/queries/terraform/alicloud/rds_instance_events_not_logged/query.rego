package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

logs_list = {"rds_enabled", "rds_ti_enabled", "rds_slow_enabled", "rds_perf_enabled"}

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.alicloud_log_audit[name]
	variable_map := resource.variable_map
	some log in logs_list
	not common_lib.valid_key(variable_map, log)

	result := {
		"documentId": doc.id,
		"resourceType": "alicloud_log_audit",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_log_audit[%s].variable_map", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' parameter value should be 'true'", [log]),
		"keyActualValue": sprintf("'%s' parameter is not defined", [log]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_log_audit", name, "variable_map"], []),
		"remediation": sprintf("%s = true", [log]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.alicloud_log_audit[name]
	variable_map := resource.variable_map
	some log in logs_list
	variable_map[log] == "false"

	result := {
		"documentId": doc.id,
		"resourceType": "alicloud_log_audit",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_log_audit[%s].variable_map.%s", [name, log]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' parameter value should be 'true'", [log]),
		"keyActualValue": sprintf("'%s' parameter value is 'false'", [log]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_log_audit", name, "variable_map", log], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
