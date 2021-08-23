package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_app_service[name]

	not common_lib.valid_key(resource, "auth_settings")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].auth_settings' is defined", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].auth_settings' is undefined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_app_service[name]

	resource.auth_settings.enabled == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_app_service[%s].auth_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].auth_settings.enabled' is true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].auth_settings.enabled' is false", [name]),
	}
}
