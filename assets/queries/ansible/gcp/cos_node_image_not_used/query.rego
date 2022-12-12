package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_container_node_pool", "gcp_container_node_pool"}
	gcp_container := task[modules[m]]
	ansLib.checkState(gcp_container)

	not startswith(lower(gcp_container.config.image_type), "cos")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.config.image_type", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_node_pool.config.image_type should start with 'COS'",
		"keyActualValue": "gcp_container_node_pool.config.image_type does not start with 'COS'",
	}
}
