package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	container_task := task["google.cloud.gcp_container_node_pool"]

	ansLib.checkState(container_task)
	object.get(container_task, "management", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'management' is defined",
		"keyActualValue": "'management' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	container_task := task["google.cloud.gcp_container_node_pool"]
	management := container_task.management

	ansLib.checkState(container_task)
	object.get(management, "auto_upgrade", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.management", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'management.auto_upgrade' is defined",
		"keyActualValue": "'management.auto_upgrade' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	container_task := task["google.cloud.gcp_container_node_pool"]
	auto_upgrade := container_task.management.auto_upgrade

	ansLib.checkState(container_task)
	not ansLib.isAnsibleTrue(auto_upgrade)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'management.auto_upgrade' is true",
		"keyActualValue": "'management.auto_upgrade' is false",
	}
}
