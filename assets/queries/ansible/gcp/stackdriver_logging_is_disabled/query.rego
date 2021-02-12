package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "logging_service", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.logging_service is defined",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.logging_service is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	is_string(cluster.logging_service)
	lower(cluster.logging_service) == "none"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.logging_service", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.logging_service is different from 'none'",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.logging_service is 'none'",
	}
}
