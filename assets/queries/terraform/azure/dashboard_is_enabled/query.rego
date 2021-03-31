package Cx

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	profile := cluster.addon_profile
	kube := profile.kube_dashboard

	kube.enabled == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].addon_profile.kube_dashboard.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.kube_dashboard.enabled' is false or undefined", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].addon_profile.kube_dashboard.enabled' is true", [name]),
	}
}
