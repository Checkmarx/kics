package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	function := input.document[i].resource.azurerm_app_service[name]

	function.site_config.ftps_state == "AllAllowed"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s].site_config.ftps_state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.ftps_state' is not set to 'AllAllowed'", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.ftps_state' is set to 'AllAllowed'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "ftps_state"], []),
	}
}
