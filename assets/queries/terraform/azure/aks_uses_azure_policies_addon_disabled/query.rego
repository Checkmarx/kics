package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name].addon_profile.azure_policy

	cluster.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].addon_profile.azure_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.azure_policy.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.azure_policy.enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "addon_profile", "azure_policy", "enabled"], []),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name].addon_profile

	not common_lib.valid_key(cluster, "azure_policy")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].addon_profile", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.azure_policy' is defined and set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.azure_policy' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "addon_profile"], []),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	not common_lib.valid_key(cluster, "addon_profile")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile' is defined and set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], []),
	}
}
