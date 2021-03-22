package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_container_node_pool", "gcp_container_node_pool"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpContainer := task[modules[m]]
	ansLib.checkState(gcpContainer)

	object.get(gcpContainer, "management", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_node_pool.management is defined",
		"keyActualValue": "gcp_container_node_pool.management is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpContainer := task[modules[m]]
	ansLib.checkState(gcpContainer)

	not ansLib.isAnsibleTrue(gcpContainer.management.auto_repair)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.management.auto_repair", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_node_pool.management.auto_repair is set to true",
		"keyActualValue": "gcp_container_node_poolmanagement.auto_repair is set to false",
	}
}
