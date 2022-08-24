package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# for deprecated version (before AzureRM 3.0)
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_app_service[name]
	python_version := resource.site_config.python_version
    to_number(python_version) != 3.10
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s].site_config.python_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "attribute 'python_version' should be the latest avaliable stable version (3.10)",
		"keyActualValue": "'python_version' is not the latest avaliable stable version (3.10)",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "python_version"], []),
	}
}

# After 3.0, for windows
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_windows_web_app[name]
    python_version := resource.site_config.application_stack.python_version
	python_version != "v3.10"
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_web_app",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_windows_web_app[%s].site_config.application_stack.python_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "attribute 'python_version' should be the latest avaliable stable version (3.10)",
		"keyActualValue": "'python_version' is not the latest avaliable stable version (3.10)",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_web_app", name, "site_config", "application_stack", "python_version"], []),
	}
}

# After 3.0, for linux
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_linux_web_app[name]
    python_version := resource.site_config.application_stack.python_version
	to_number(python_version) != 3.10
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_linux_web_app",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_linux_web_app[%s].site_config.application_stack.python_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "attribute 'python_version' should be the latest avaliable stable version (3.10)",
		"keyActualValue": "'python_version' is not the latest avaliable stable version (3.10)",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_web_app", name, "site_config", "application_stack", "python_version"], []),
	}
}
