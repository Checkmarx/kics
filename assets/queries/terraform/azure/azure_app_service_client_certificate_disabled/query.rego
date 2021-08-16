package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource.azurerm_app_service[name]
    
    not common_lib.valid_key(resource, "client_cert_enabled")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is defined", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabeld' is undefined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource.azurerm_app_service[name]

	resource.client_cert_enabled == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_app_service[%s].client_cert_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is false", [name]),
	}
}
