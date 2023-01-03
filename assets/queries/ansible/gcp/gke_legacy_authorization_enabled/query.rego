package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	ansLib.isAnsibleTrue(cluster.legacy_abac.enabled)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.legacy_abac.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.legacy_abac.enabled should be set to false",
		"keyActualValue": "gcp_container_cluster.legacy_abac.enabled is true",
	}
}
