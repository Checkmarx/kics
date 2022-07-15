package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not common_lib.valid_key(cluster, "private_cluster_config")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.private_cluster_config should be defined",
		"keyActualValue": "gcp_container_cluster.private_cluster_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["enable_private_endpoint", "enable_private_nodes"]
	field := fields[f]

	not common_lib.valid_key(cluster.private_cluster_config, field)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("gcp_container_cluster.private_cluster_config.%s should be defined", [fields[f]]),
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_cluster_config.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_container_cluster.private_cluster_config.%s should be true", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.private_cluster_config.%s is false", [fields[f]]),
	}
}
