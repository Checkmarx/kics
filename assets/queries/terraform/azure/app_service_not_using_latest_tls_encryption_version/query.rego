package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	app := input.document[i].resource.azurerm_app_service[name]

	app.site_config.min_tls_version != 1.2

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s].site_config.min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.min_tls_version' is set to'1.2'", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.min_tls_version' is not set to '1.2'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "min_tls_version"], []),
	}
}

CxPolicy[result] {
	app := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(app, "site_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name], []),
	}
}
