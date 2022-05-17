package Cx

import data.generic.common as common_lib

# for deprecated version (before AzureRM 3.0)
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_app_service[name]
	php_version := resource.site_config.php_version
    to_number(php_version) != 7.4
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s].site_config.php_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "for the attribute 'php_version' to be the lastest version (7.4)",
		"keyActualValue": "'php_version' is not the lastest version (7.4)",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "php_version"], []),
	}
}

# After 3.0, for windows
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_windows_web_app[name]
    php_version := resource.site_config.application_stack.php_version
	php_version != "v7.4"
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_windows_web_app[%s].site_config.application_stack.php_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "for the attribute 'php_version' to be the lastest version (7.4)",
		"keyActualValue": "'php_version' is not the lastest version (7.4)",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_web_app", name, "site_config", "application_stack", "php_version"], []),
	}
}

# After 3.0, for linux
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_linux_web_app[name]
    php_version := resource.site_config.application_stack.php_version
	to_number(php_version) != 8.0
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_linux_web_app[%s].site_config.application_stack.php_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "for the attribute 'php_version' to be the lastest version (8.0)",
		"keyActualValue": "'php_version' is not the lastest version (8.0)",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_web_app", name, "site_config", "application_stack", "php_version"], []),
	}
}
