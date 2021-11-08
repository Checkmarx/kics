package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	not common_lib.valid_key(function, "identity")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_function_app[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].identity' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].identity' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name], []),
	}
}
