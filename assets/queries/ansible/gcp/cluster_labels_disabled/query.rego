package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not common_lib.valid_key(cluster, "resource_labels")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s is defined and not null", [modules[m]]),
		"keyActualValue": sprintf("%s is undefined and null", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	common_lib.valid_key(cluster, "resource_labels")
	cluster.resource_labels == ""

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.resource_labels", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is not empty", [modules[m]]),
		"keyActualValue": sprintf("%s is empty", [modules[m]]),
	}
}
