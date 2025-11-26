package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	all_logs := {x | x := input.document[_].resource.azurerm_monitor_diagnostic_setting}
	resource := input.document[i].resource.azurerm_kubernetes_cluster[name]


	result := {
		"documentId": input.document[i].id,
		"resourceType": "resource_type",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource_type[%s]", [name]),
		"issueType": "issuetype_template",
		"keyExpectedValue": sprintf("'resource_type[%s].site_config' should be defined and not null", [name]),
		"keyActualValue": sprintf("'resource_type[%s].site_config' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "resource_type", name], [])
	}
}
