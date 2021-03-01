package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcp_container := task["google.cloud.gcp_container_node_pool"]
	image_type := gcp_container.config.image_type

	ansLib.checkState(gcp_container)
	lower(image_type) != "cos"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.config.image_type", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'config.image_type' is equal to 'COS'",
		"keyActualValue": "'config.image_type' is not equal to 'COS'",
	}
}
