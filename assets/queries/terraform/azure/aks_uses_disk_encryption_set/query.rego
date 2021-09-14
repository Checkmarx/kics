package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	not common_lib.valid_key(cluster, "disk_encryption_set_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].disk_encryption_set_id' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].disk_encryption_set_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], []),
	}
}
