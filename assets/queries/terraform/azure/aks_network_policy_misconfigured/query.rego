package Cx

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.network_profile
	policy := profile.network_policy

	not isValidPolicy(policy)

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
	object.get(profile, "network_policy", "undefined") == "undefined"

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
	object.get(cluster, "network_profile", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' is set", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' is undefined", [name]),
	}
}

isValidPolicy(policy) {
	policy == "azure"
} else {
	policy == "calico"
} else = false {
	true
}
