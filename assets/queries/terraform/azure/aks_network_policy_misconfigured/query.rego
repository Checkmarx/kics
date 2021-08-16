package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.network_profile
	policy := profile.network_policy

	not validPolicy(policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].network_profile.network_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is either 'azure' or 'calico'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is %s", [name, policy]),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.network_profile
	not common_lib.valid_key(profile, "network_policy")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].network_profile", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is set and is either 'azure' or 'calico'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is undefined", [name]),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	not common_lib.valid_key(cluster, "network_profile")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' is set", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' is undefined", [name]),
	}
}

validPolicy("azure") = true

validPolicy("calico") = true
