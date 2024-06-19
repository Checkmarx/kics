package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	not common_lib.valid_key(cluster, "log_agent")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'log_agent' should be defined and not null",
		"keyActualValue": "'log_agent' is undefined or null",
		"searchLine":common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name], []),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	common_lib.valid_key(cluster, "log_agent")

    log_agent := cluster.log_agent
    log_agent.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].log_agent.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].log_agent.enabled should be set to 'true'", [name]),
        "keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].log_agent.enabled is not set to 'true'", [name]),
        "searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "log_agent", "enabled"], []),
	}
}
