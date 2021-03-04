package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(container_cluster)
	object.get(container_cluster, "master_authorized_networks_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'master_authorized_networks_config' is defined",
		"keyActualValue": "'master_authorized_networks_config' is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(container_cluster)
	object.get(container_cluster.master_authorized_networks_config, "enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_cluster}}.master_authorized_networks_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'master_authorized_networks_config.enabled' is defined",
		"keyActualValue": "'master_authorized_networks_config.enabled' is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(container_cluster)
	not ansLib.isAnsibleTrue(container_cluster.master_authorized_networks_config.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_cluster}}.master_authorized_networks_config.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'master_authorized_networks_config.enabled' is true",
		"keyActualValue": "'master_authorized_networks_config.enabled' is false",
	}
}
