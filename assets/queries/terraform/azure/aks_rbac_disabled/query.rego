package Cx

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	object.get(cluster, "role_based_access_control", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control' is defined", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control' is undefined", [name]),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	rbac := cluster.role_based_access_control

	rbac.enabled != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].role_based_access_control.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control.enabled' is not set to true", [name]),
	}
}
