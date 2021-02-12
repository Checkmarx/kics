package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	ansLib.isAnsibleTrue(cluster.legacy_abac.enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.legacy_abac.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.legacy_abac.enabled is false",
		"keyActualValue": "google.cloud.gcp_container_cluster.legacy_abac.enabled is true",
	}
}
