package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_kubernetes_cluster[name]
	not common_lib.valid_key(resource, "microsoft_defender")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].microsoft_defender' should be configured", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].microsoft_defender' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], []),
		"remediation": "microsoft_defender {\n    log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id\n  }",
		"remediationType": "addition",
	}
}
