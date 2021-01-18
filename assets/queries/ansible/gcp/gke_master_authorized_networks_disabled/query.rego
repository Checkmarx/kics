package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	container_cluster := task["google.cloud.gcp_container_cluster"]

	object.get(container_cluster, "master_authorized_networks_config", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'master_authorized_networks_config' is defined",
		"keyActualValue": "'master_authorized_networks_config' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	container_cluster := task["google.cloud.gcp_container_cluster"]

	object.get(container_cluster.master_authorized_networks_config, "enabled", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_cluster}}.master_authorized_networks_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'master_authorized_networks_config.enabled' is defined",
		"keyActualValue": "'master_authorized_networks_config.enabled' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	container_cluster := task["google.cloud.gcp_container_cluster"]

	not isAnsibleTrue(container_cluster.master_authorized_networks_config.enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_cluster}}.master_authorized_networks_config.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'master_authorized_networks_config.enabled' is true",
		"keyActualValue": "'master_authorized_networks_config.enabled' is false",
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
