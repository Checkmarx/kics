package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	not common_lib.valid_key(function, "client_cert_mode")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_function_app[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].client_cert_mode' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].client_cert_mode' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name], []),
	}
}

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	function.client_cert_mode != "Required"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_function_app[%s].client_cert_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].client_cert_mode' is set to 'Required'", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].client_cert_mode' is not set to 'Required'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "client_cert_mode"], []),
	}
}
