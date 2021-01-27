package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	gcpContainer := task["google.cloud.gcp_container_node_pool"]
	containerName := task.name

	object.get(gcpContainer, "management", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_node_pool}}", [containerName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_node_pool.gcpContainer.management should be defined",
		"keyActualValue": "google.cloud.gcp_container_node_pool.gcpContainer.management is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	gcpContainer := task["google.cloud.gcp_container_node_pool"]
	containerName := task.name
	not isAnsibleTrue(gcpContainer.management.auto_repair)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_node_pool}}.management.auto_repair", [containerName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_node_pool.gcpContainer.management.auto_repair should be set to true",
		"keyActualValue": "google.cloud.gcp_container_node_pool.gcpContainer.management.auto_repair is set to false",
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
	answer == true
}
