package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	function := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(function, "site_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name], []),
	}
}

CxPolicy[result] {
	function := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(function.site_config, "ftps_state")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s].site_config'", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.ftps_state' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.ftps_state' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config"], []),
	}
}

CxPolicy[result] {
	function := input.document[i].resource.azurerm_app_service[name]

	function.site_config.ftps_state != "FtpsOnly"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s].site_config.ftps_state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.ftps_state' is set to 'FtpsOnly'", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.ftps_state' is not set to 'FtpsOnly'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "ftps_state"], []),
	}
}
