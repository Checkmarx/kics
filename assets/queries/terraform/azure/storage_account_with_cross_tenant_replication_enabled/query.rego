package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]

	resource.cross_tenant_replication_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey" : sprintf("azurerm_storage_account[%s].cross_tenant_replication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].cross_tenant_replication_enabled' should be set to false", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].cross_tenant_replication_enabled' is set to true", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "cross_tenant_replication_enabled"], [])
	}
}
