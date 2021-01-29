package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name

	isAnsibleTrue(cluster.legacy_abac.enabled)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.legacy_abac.enabled", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.legacy_abac.enabled is false",
		"keyActualValue": "google.cloud.gcp_container_cluster.legacy_abac.enabled is true",
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
