package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "private_cluster_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config is defined", [task.name]),
		"keyActualValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster.private_cluster_config, "enable_private_nodes", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_nodes is defined", [task.name]),
		"keyActualValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_nodes is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster.private_cluster_config, "enable_private_endpoint", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_endpoint is defined", [task.name]),
		"keyActualValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_endpoint is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	not ansLib.isAnsibleTrue(cluster.private_cluster_config.enable_private_endpoint)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config.enable_private_endpoint", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_endpoint is true", [task.name]),
		"keyActualValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_endpoint is false", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	not ansLib.isAnsibleTrue(cluster.private_cluster_config.enable_private_nodes)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config.enable_private_nodes", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_nodes is true", [task.name]),
		"keyActualValue": sprintf("{{google.cloud.gcp_container_cluster}}[%s].private_cluster_config.enable_private_nodes is false", [task.name]),
	}
}
