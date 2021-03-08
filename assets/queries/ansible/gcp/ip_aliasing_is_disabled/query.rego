package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster, "ip_allocation_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.ip_allocation_policy is defined",
		"keyActualValue": "gcp_container_cluster.ip_allocation_policy is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster.ip_allocation_policy, "use_ip_aliases", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ip_allocation_policy", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.ip_allocation_policy.use_ip_aliases is set to true",
		"keyActualValue": "gcp_container_cluster.ip_allocation_policy.use_ip_aliases is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not ansLib.isAnsibleTrue(cluster.ip_allocation_policy.use_ip_aliases)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ip_allocation_policy.use_ip_aliases", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.ip_allocation_policy.use_ip_aliases is true",
		"keyActualValue": "gcp_container_cluster.ip_allocation_policy.use_ip_aliases is false",
	}
}
