package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_container_node_pool", "gcp_container_node_pool"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_task := task[modules[m]]
	ansLib.checkState(container_task)

	object.get(container_task, "management", "undefined") == "undefined"

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
	container_task := task[modules[m]]
	management := container_task.management

	ansLib.checkState(container_task)
	object.get(management, "auto_upgrade", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.management", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_node_pool.management.auto_upgrade is defined",
		"keyActualValue": "gcp_container_node_pool.management.auto_upgrade is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_task := task[modules[m]]
	auto_upgrade := container_task.management.auto_upgrade

	ansLib.checkState(container_task)
	not ansLib.isAnsibleTrue(auto_upgrade)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.management.auto_upgrade", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_node_pool.management.auto_upgrade is true",
		"keyActualValue": "gcp_container_node_pool.management.auto_upgrade is false",
	}
}
