package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_app_service[name]

	not common_lib.valid_key(resource, "client_cert_enabled")

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabeld' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name], []),
		"remediation": "client_cert_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_app_service[name]

	resource.client_cert_enabled == false

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s].client_cert_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "client_cert_enabeld"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
