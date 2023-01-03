package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.network_profile
	policy := profile.network_policy

	not validPolicy(policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].network_profile.network_policy", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name, "network_profile", "network_policy"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' should be either 'azure' or 'calico'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is %s", [name, policy]),
		"remediation": json.marshal({
			"before": sprintf("%s", [policy]),
			"after": "azure"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.network_profile
	not common_lib.valid_key(profile, "network_policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].network_profile", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name, "network_profile"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' should be set to either 'azure' or 'calico'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is undefined", [name]),
		"remediation": "network_policy = \"azure\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	not common_lib.valid_key(cluster, "network_profile")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' is undefined", [name]),
		"remediation": "network_profile {\n\t\tnetwork_policy = \"azure\"\n\t}",
		"remediationType": "addition",
	}
}

validPolicy("azure") = true

validPolicy("calico") = true
