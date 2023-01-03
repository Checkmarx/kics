package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_app_service[name]

	not common_lib.valid_key(resource, "auth_settings")

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].auth_settings' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].auth_settings' is undefined", [name]),
		"remediation": "auth_settings {\n\t\tenabled = true\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_app_service[name]

	resource.auth_settings.enabled == false

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s].auth_settings.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service", name, "auth_settings", "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].auth_settings.enabled' should be true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].auth_settings.enabled' is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
