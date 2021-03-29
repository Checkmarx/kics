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
	fields := ["enable_private_endpoint", "enable_private_nodes"]

	object.get(cluster.private_cluster_config, fields[f], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("gcp_container_cluster.private_cluster_config.%s is defined", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.private_cluster_config.%s is undefined", [fields[f]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["enable_private_endpoint", "enable_private_nodes"]

	not ansLib.isAnsibleTrue(cluster.private_cluster_config[fields[f]])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_container_cluster.private_cluster_config.%s is true", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.private_cluster_config.%s is false", [fields[f]]),
	}
}
