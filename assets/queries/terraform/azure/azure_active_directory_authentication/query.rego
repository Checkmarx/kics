package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	active := input.document[i].resource.azurerm_service_fabric_cluster[name].azure_active_directory

	not common_lib.valid_key(active, "tenant_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_service_fabric_cluster[%s].azure_active_directory", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_service_fabric_cluster[%s].azure_active_directory.tenant_id' is defined and not null", [name]),
		"keyActualValue": sprintf("'aazurerm_service_fabric_cluster[%s].azure_active_directory.tenant_id' is undefined or null", [name]),
	}
}
