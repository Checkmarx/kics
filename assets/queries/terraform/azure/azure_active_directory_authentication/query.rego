package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	active := input.document[i].resource.azurerm_service_fabric_cluster[name].azure_active_directory

	not common_lib.valid_key(active, "tenant_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_service_fabric_cluster",
		"resourceName": tf_lib.get_resource_name(active, name),
		"searchKey": sprintf("azurerm_service_fabric_cluster[%s].azure_active_directory", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_service_fabric_cluster[%s].azure_active_directory.tenant_id' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_service_fabric_cluster[%s].azure_active_directory.tenant_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_service_fabric_cluster", name, "azure_active_directory"], []),
	}
}

CxPolicy[result] {
	azure := input.document[i].resource.azurerm_service_fabric_cluster[name]

	not common_lib.valid_key(azure, "azure_active_directory")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_service_fabric_cluster",
		"resourceName": tf_lib.get_resource_name(azure, name),
		"searchKey": sprintf("azurerm_service_fabric_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_service_fabric_cluster[%s].azure_active_directory' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_service_fabric_cluster[%s].azure_active_directory' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_service_fabric_cluster", name], []),
	}
}
