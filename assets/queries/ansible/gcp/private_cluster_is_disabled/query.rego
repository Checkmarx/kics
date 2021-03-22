package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster, "private_cluster_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.private_cluster_config is defined",
		"keyActualValue": "gcp_container_cluster.private_cluster_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster.private_cluster_config, "enable_private_nodes", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.private_cluster_config.enable_private_nodes is defined",
		"keyActualValue": "gcp_container_cluster.private_cluster_config.enable_private_nodes is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster.private_cluster_config, "enable_private_endpoint", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.private_cluster_config.enable_private_endpoint is defined",
		"keyActualValue": "gcp_container_cluster.private_cluster_config.enable_private_endpoint is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not ansLib.isAnsibleTrue(cluster.private_cluster_config.enable_private_endpoint)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config.enable_private_endpoint", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.private_cluster_config.enable_private_endpoint is true",
		"keyActualValue": "gcp_container_cluster.private_cluster_config.enable_private_endpoint is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not ansLib.isAnsibleTrue(cluster.private_cluster_config.enable_private_nodes)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config.enable_private_nodes", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.private_cluster_config.enable_private_nodes is true",
		"keyActualValue": "gcp_container_cluster.private_cluster_config.enable_private_nodes is false",
	}
}
