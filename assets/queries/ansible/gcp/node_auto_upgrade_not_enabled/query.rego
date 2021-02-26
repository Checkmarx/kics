package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_task := task["google.cloud.gcp_container_node_pool"]

	ansLib.checkState(container_task)
	object.get(container_task, "management", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.management is defined",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.management is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_task := task["google.cloud.gcp_container_node_pool"]
	management := container_task.management

	ansLib.checkState(container_task)
	object.get(management, "auto_upgrade", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.management", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade is defined",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_task := task["google.cloud.gcp_container_node_pool"]
	auto_upgrade := container_task.management.auto_upgrade

	ansLib.checkState(container_task)
	not ansLib.isAnsibleTrue(auto_upgrade)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade is true",
		"keyActualValue": "{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade is false",
	}
}
