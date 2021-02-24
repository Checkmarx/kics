package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpContainer := task["google.cloud.gcp_container_node_pool"]

	ansLib.checkState(gcpContainer)
	object.get(gcpContainer, "management", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_node_pool}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management is defined",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpContainer := task["google.cloud.gcp_container_node_pool"]

	ansLib.checkState(gcpContainer)
	not ansLib.isAnsibleTrue(gcpContainer.management.auto_repair)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_node_pool}}.management.auto_repair", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management.auto_repair is set to true",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management.auto_repair is set to false",
	}
}
