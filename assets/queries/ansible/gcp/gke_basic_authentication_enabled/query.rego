package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	not common_lib.valid_key(cluster, "master_auth")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.master_auth should be defined",
		"keyActualValue": "gcp_container_cluster.master_auth is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["username", "password"]
	field := fields[f]

	not common_lib.valid_key(cluster.master_auth, field)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("gcp_container_cluster.master_auth.%s should be defined", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.master_auth.%s is undefined", [fields[f]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["username", "password"]

	is_string(cluster.master_auth[fields[f]])
	count(cluster.master_auth[fields[f]]) > 0

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_container_cluster.master_auth.%s should be empty", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.master_auth.%s is not empty", [fields[f]]),
	}
}
