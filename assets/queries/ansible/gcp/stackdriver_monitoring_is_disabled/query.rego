package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "monitoring_service", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.monitoring_service is defined",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.monitoring_service is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	is_string(cluster.monitoring_service)
	lower(cluster.monitoring_service) == "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.monitoring_service", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.monitoring_service is different from 'none'",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.monitoring_service is 'none'",
	}
}
