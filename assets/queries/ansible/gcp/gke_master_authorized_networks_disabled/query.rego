package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task[modules[m]]
	ansLib.checkState(container_cluster)

	not common_lib.valid_key(container_cluster, "master_authorized_networks_config")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.master_authorized_networks_config should be defined",
		"keyActualValue": "gcp_container_cluster.master_authorized_networks_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task[modules[m]]
	ansLib.checkState(container_cluster)

	not common_lib.valid_key(container_cluster.master_authorized_networks_config, "enabled")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_authorized_networks_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.master_authorized_networks_config.enabled should be defined",
		"keyActualValue": "gcp_container_cluster.master_authorized_networks_config.enabled is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task[modules[m]]
	ansLib.checkState(container_cluster)

	not ansLib.isAnsibleTrue(container_cluster.master_authorized_networks_config.enabled)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_authorized_networks_config.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.master_authorized_networks_config.enabled should be true",
		"keyActualValue": "gcp_container_cluster.master_authorized_networks_config.enabled is false",
	}
}
