package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	cluster.state == "present"
	clusterName := task.name

	object.get(cluster, "master_auth", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [clusterName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.master_auth is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name

	object.get(cluster.master_auth, "client_certificate_config", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth", [clusterName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.client_certificate_config is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.master_auth.client_certificate_config is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	cluster := task["google.cloud.gcp_container_cluster"]
	clusterName := task.name

	ansLib.isAnsibleFalse(cluster.master_auth.client_certificate_config.issue_client_certificate)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth.client_certificate_config.issue_client_certificate", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.password is true",
		"keyActualValue": "google.cloud.gcp_container_cluster.master_auth.password is false",
	}
}
