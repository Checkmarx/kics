package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	not common_lib.valid_key(cluster, "role_based_access_control")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control' is undefined or null", [name]),
		"remediation": "role_based_access_control {\n\t\tenabled = true\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	rbac := cluster.role_based_access_control

	rbac.enabled != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].role_based_access_control.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name ,"role_based_access_control", "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control.enabled' is not set to true", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
