package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name

	object.get(cluster, "ip_allocation_policy", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [clusterName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.ip_allocation_policy should be defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.ip_allocation_policy is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name
	cluster.ip_allocation_policy

	object.get(cluster.ip_allocation_policy, "use_ip_aliases", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.ip_allocation_policy", [clusterName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.ip_allocation_policy.use_ip_aliases should be set to true",
		"keyActualValue": "google.cloud.gcp_container_cluster.ip_allocation_policy.use_ip_aliases is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name

	not isAnsibleTrue(cluster.ip_allocation_policy.use_ip_aliases)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.ip_allocation_policy.use_ip_aliases", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.ip_allocation_policy.use_ip_aliases is true",
		"keyActualValue": "google.cloud.gcp_container_cluster.ip_allocation_policy.use_ip_aliases is false",
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
