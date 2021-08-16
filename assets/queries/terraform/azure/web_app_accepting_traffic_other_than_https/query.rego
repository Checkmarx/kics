package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(resource, "https_only")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].https_only' is set", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].https_only' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_app_service[name]

	resource.https_only != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_app_service[%s].https_only", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].https_only' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].https_only' is not set to true", [name]),
	}
}
