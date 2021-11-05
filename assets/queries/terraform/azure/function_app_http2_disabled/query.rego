package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	app := input.document[i].resource.azurerm_function_app[name]

	not common_lib.valid_key(app, "site_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_function_app[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name], []),
	}
}

CxPolicy[result] {
	app := input.document[i].resource.azurerm_function_app[name]

	not common_lib.valid_key(app.site_config, "http2_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_function_app[%s].site_config", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config.http2_enabled' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config.http2_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "site_config"], []),
	}
}

CxPolicy[result] {
	app := input.document[i].resource.azurerm_function_app[name]

	app.site_config.http2_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_function_app[%s].site_config.http2_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config.http2_enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config.http2_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "site_config", "http2_enabled"], []),
	}
}
