package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	object.get(task["google.cloud.gcp_container_node_pool"], "management", "undefined") == "undefined"

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
	task := getTasks(document)[t]

	management := task["google.cloud.gcp_container_node_pool"].management
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
	task := getTasks(document)[t]

	auto_upgrade := task["google.cloud.gcp_container_node_pool"].management.auto_upgrade
	not isAnsibleTrue(auto_upgrade)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.management.auto_upgrade", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'management.auto_upgrade' is true",
		"keyActualValue": "'management.auto_upgrade' is false",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
