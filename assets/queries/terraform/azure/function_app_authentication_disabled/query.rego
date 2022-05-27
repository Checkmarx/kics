package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	not common_lib.valid_key(function, "auth_settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_function_app",
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("azurerm_function_app[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].auth_settings' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].auth_settings' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name], []),
	}
}

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	function.auth_settings.enabled != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_function_app",
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("azurerm_function_app[%s].auth_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].auth_settings.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].auth_settings.enabled' is not set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "auth_settings", "enabled"], []),
	}
}
