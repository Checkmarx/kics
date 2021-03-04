package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "resource_labels", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is defined", [task.name]),
		"keyActualValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	cluster.resource_labels == null

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.resource_labels", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is not null", [task.name]),
		"keyActualValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is null", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	count(cluster.resource_labels) == 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.resource_labels", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is not empty", [task.name]),
		"keyActualValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is empty", [task.name]),
	}
}
