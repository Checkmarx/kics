package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster, "resource_labels", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.resource_labels is defined",
		"keyActualValue": "gcp_container_cluster.resource_labels is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	commonLib.emptyOrNull(cluster.resource_labels)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.resource_labels", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.resource_labels is not null nor empty",
		"keyActualValue": "gcp_container_cluster.resource_labels is null or empty",
	}
}
