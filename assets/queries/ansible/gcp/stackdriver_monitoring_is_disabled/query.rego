package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name

	object.get(cluster, "monitoring_service", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [clusterName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.monitoring_service is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.monitoring_service is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name
	is_string(cluster.monitoring_service)
	lower(cluster.monitoring_service) == "none"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.monitoring_service", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.monitoring_service is different from 'none'",
		"keyActualValue": "google.cloud.gcp_container_cluster.monitoring_service is 'none'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
