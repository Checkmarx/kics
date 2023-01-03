package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	not common_lib.valid_key(function.site_config, "ftps_state")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_function_app",
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("azurerm_function_app[%s].site_config'", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config.ftps_state' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config.ftps_state' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "site_config"], []),
		"remediation": "ftps_state = \"FtpsOnly\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	function := input.document[i].resource.azurerm_function_app[name]

	function.site_config.ftps_state == "AllAllowed"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_function_app",
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("azurerm_function_app[%s].site_config.ftps_state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config.ftps_state' should not be set to 'AllAllowed'", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config.ftps_state' is set to 'AllAllowed'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "site_config", "ftps_state"], []),
		"remediation": json.marshal({
			"before": "AllAllowed",
			"after": "FtpsOnly"
		}),
		"remediationType": "replacement",
	}
}
