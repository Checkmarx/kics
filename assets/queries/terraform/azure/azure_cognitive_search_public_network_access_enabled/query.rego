package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	search := input.document[i].resource.azurerm_search_service[name]

	not common_lib.valid_key(search, "public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(search, name),
		"searchKey": sprintf("azurerm_search_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_search_service[%s].public_network_access_enabled' should be defined and set to false", [name]),
		"keyActualValue": sprintf("'azurerm_search_service[%s].public_network_access_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name], []),
		"remediation": "public_network_access_enabled = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	search := input.document[i].resource.azurerm_search_service[name]

	search.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(search, name),
		"searchKey": sprintf("azurerm_search_service[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_search_service[%s].public_network_access_enabled' should be set to false", [name]),
		"keyActualValue": sprintf("'azurerm_search_service[%s].public_network_access_enabled' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
