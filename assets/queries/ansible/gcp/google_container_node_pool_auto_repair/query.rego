package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	gcpContainer := task["google.cloud.gcp_container_node_pool"]

	ansLib.checkState(gcpContainer)
	object.get(gcpContainer, "management", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_node_pool}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management is defined",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	gcpContainer := task["google.cloud.gcp_container_node_pool"]

	ansLib.checkState(gcpContainer)
	not ansLib.isAnsibleTrue(gcpContainer.management.auto_repair)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_node_pool}}.management.auto_repair", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management.auto_repair is set to true",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.gcpContainer.management.auto_repair is set to false",
	}
}
