package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	# before azurerm 3.0
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name].addon_profile.azure_policy

	cluster.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].addon_profile.azure_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.azure_policy.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.azure_policy.enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "addon_profile", "azure_policy", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {

	# after azurerm 3.0

	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	cluster.azure_policy_enabled == false


	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].azure_policy_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].azure_policy_enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].azure_policy_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "azure_policy_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
