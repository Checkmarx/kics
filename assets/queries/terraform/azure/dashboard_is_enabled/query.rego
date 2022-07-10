package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.addon_profile
	kube := profile.kube_dashboard

	kube.enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].addon_profile.kube_dashboard.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.kube_dashboard.enabled' should be set to false or undefined", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.kube_dashboard.enabled' is true", [name]),
	}
}
