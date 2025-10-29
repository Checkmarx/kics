package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_function_app", "azurerm_linux_function_app", "azurerm_windows_function_app"}

CxPolicy[result] { # for legacy "azurerm_function_app" -- ftps_state defaults to "AllAllowed"
	function := input.document[i].resource.azurerm_function_app[name]

	results := get_path(function,name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_function_app",
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": results.searchKey,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config.ftps_state' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config.ftps_state' is undefined or null", [name]),
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType,
	}
}

get_path(function,name) = results {
	not common_lib.valid_key(function, "site_config")
	results := {
		"searchKey": sprintf("azurerm_function_app[%s]'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name], []),
		"remediation": null,
		"remediationType": null,
	}	
} else = results {
	not common_lib.valid_key(function.site_config, "ftps_state")
	results := {
		"searchKey": sprintf("azurerm_function_app[%s].site_config'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "site_config"], []),
		"remediation": "ftps_state = \"FtpsOnly\"",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	function := input.document[i].resource[types[t]][name]

	function.site_config.ftps_state == "AllAllowed"

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("%s[%s].site_config.ftps_state", [types[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.ftps_state' should not be set to 'AllAllowed'", [types[t], name]),
		"keyActualValue": sprintf("'%s[%s].site_config.ftps_state' is set to 'AllAllowed'", [types[t], name]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name, "site_config", "ftps_state"], []),
		"remediation": json.marshal({
			"before": "AllAllowed",
			"after": "FtpsOnly"
		}),
		"remediationType": "replacement",
	}
}
