package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_linux_virtual_machine", "azurerm_linux_virtual_machine_scale_set", "azurerm_windows_virtual_machine", "azurerm_windows_virtual_machine_scale_set"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	results := get_results(resource, types[t], name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'%s[%s].encryption_at_host_enabled' should be defined and set to 'true'", [types[t], name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, type, name) = results {
	not common_lib.valid_key(resource, "encryption_at_host_enabled")
	results := {
		"searchKey": sprintf("%s[%s]", [type, name]),
		"issueType": "MissingAttribute",
		"keyActualValue": sprintf("'%s[%s].encryption_at_host_enabled' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], [])
	}
} else = results {
	resource.encryption_at_host_enabled != true
	results := {
		"searchKey": sprintf("%s[%s].encryption_at_host_enabled", [type, name]),
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'%s[%s].encryption_at_host_enabled' is set to '%s'", [type, name, resource.encryption_at_host_enabled]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "encryption_at_host_enabled"], [])
	}
}
