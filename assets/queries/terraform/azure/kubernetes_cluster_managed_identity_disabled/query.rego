package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    kubernetes_cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

    not common_lib.valid_key(kubernetes_cluster, "identity")

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(kubernetes_cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' field should have the values 'SystemAssigned' or 'UserAssigned' defined inside the 'identity' block",
		"keyActualValue": "'identity' block is not defined",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], []),
        "remediationType": "addition",
        "remediation": "identity {\n\t\ttype = \"SystemAssigned\"\n\t}",
    }
}