package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not common_lib.valid_key(cluster, "monitoring_service")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.monitoring_service should be defined",
		"keyActualValue": "gcp_container_cluster.monitoring_service is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	is_string(cluster.monitoring_service)
	lower(cluster.monitoring_service) == "none"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.monitoring_service", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.monitoring_service should not be 'none'",
		"keyActualValue": "gcp_container_cluster.monitoring_service is 'none'",
	}
}
