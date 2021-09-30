package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	not common_lib.valid_key(cluster, "private_cluster_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].private_cluster_enabled' is defined and set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].private_cluster_enabled' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], []),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	cluster.private_cluster_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].private_cluster_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].private_cluster_enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].private_cluster_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "private_cluster_enabled"], []),
	}
}
