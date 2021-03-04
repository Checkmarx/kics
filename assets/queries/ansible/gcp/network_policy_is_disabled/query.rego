package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "network_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.network_policy is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.network_policy is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "addons_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.addons_config is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.addons_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster.addons_config, "network_policy_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.addons_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.addons_config.network_policy_config is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.addons_config.network_policy_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	ansLib.isAnsibleFalse(cluster.network_policy.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.network_policy.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.network_policy.enabled is true",
		"keyActualValue": "google.cloud.gcp_container_cluster.network_policy.enabled is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	ansLib.isAnsibleTrue(cluster.network_policy.enabled)
	ansLib.isAnsibleTrue(cluster.addons_config.network_policy_config.disabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.addons_config.network_policy_config.disabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.addons_config.network_policy_config.disabled is false",
		"keyActualValue": "google.cloud.gcp_container_cluster.addons_config.network_policy_config.disabled is true",
	}
}
