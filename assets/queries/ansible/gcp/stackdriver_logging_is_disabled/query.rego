package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster, "logging_service", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.logging_service is defined",
		"keyActualValue": "gcp_container_cluster.logging_service is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	is_string(cluster.logging_service)
	lower(cluster.logging_service) == "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.logging_service", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.logging_service is different from 'none'",
		"keyActualValue": "gcp_container_cluster.logging_service is 'none'",
	}
}
