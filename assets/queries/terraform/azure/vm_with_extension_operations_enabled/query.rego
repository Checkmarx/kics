package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_linux_virtual_machine", "azurerm_windows_virtual_machine", "azurerm_linux_virtual_machine_scale_set"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	results := get_results(resource, types[t], name)[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, type, name) = results {
	type == "azurerm_linux_virtual_machine_scale_set"
	not common_lib.valid_key(resource, "extension_operations_enabled")
	results := [{
		"searchKey": sprintf("azurerm_linux_virtual_machine_scale_set[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_linux_virtual_machine_scale_set[%s].extension_operations_enabled' should be defined and set to 'false'", [name]),
		"keyActualValue": sprintf("'azurerm_linux_virtual_machine_scale_set[%s].extension_operations_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_virtual_machine_scale_set", name], [])
	}]
} else = results {
	type == "azurerm_linux_virtual_machine_scale_set"
	resource.extension_operations_enabled != false
	results := [{
		"searchKey": sprintf("azurerm_linux_virtual_machine_scale_set[%s].extension_operations_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_linux_virtual_machine_scale_set[%s].extension_operations_enabled' should be defined and set to 'false'", [name]),
		"keyActualValue": sprintf("'azurerm_linux_virtual_machine_scale_set[%s].extension_operations_enabled' is set to '%s'", [name, resource.extension_operations_enabled]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_virtual_machine_scale_set", name, "extension_operations_enabled"], [])
	}]
} else = results {
	type != "azurerm_linux_virtual_machine_scale_set"
	not common_lib.valid_key(resource, "allow_extension_operations")
	results := [{
		"searchKey": sprintf("%s[%s]", [type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].allow_extension_operations' should be defined and set to 'false'", [type, name]),
		"keyActualValue": sprintf("'%s[%s].allow_extension_operations' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], [])
	}]
} else = results {
	resource.allow_extension_operations != false
	results := [{
		"searchKey": sprintf("%s[%s].allow_extension_operations", [type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].allow_extension_operations' should be defined and set to 'false'", [type, name]),
		"keyActualValue": sprintf("'%s[%s].allow_extension_operations' is set to '%s'", [type, name, resource.allow_extension_operations]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "allow_extension_operations"], [])
	}]
}
