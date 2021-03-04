package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "ip_allocation_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.ip_allocation_policy is defined",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.ip_allocation_policy is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]
	cluster.ip_allocation_policy

	ansLib.checkState(cluster)
	object.get(cluster.ip_allocation_policy, "use_ip_aliases", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.ip_allocation_policy", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.ip_allocation_policy.use_ip_aliases is set to true",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.ip_allocation_policy.use_ip_aliases is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	not ansLib.isAnsibleTrue(cluster.ip_allocation_policy.use_ip_aliases)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.ip_allocation_policy.use_ip_aliases", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.ip_allocation_policy.use_ip_aliases is true",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.ip_allocation_policy.use_ip_aliases is false",
	}
}
