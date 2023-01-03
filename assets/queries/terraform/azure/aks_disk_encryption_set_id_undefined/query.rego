package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	not common_lib.valid_key(cluster, "disk_encryption_set_id")
	is_not_ephemeral(cluster)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].disk_encryption_set_id' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].disk_encryption_set_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], []),
	}
}


is_not_ephemeral(cluster){
	not common_lib.valid_key(cluster.default_node_pool, "os_disk_type") 
} else {
	disk_type := cluster.default_node_pool.os_disk_type
	disk_type != "Ephemeral"
}
