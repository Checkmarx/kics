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
		"keyExpectedValue": "gcp_container_cluster.master_auth should be defined and not null",
		"keyActualValue": "gcp_container_cluster.master_auth is undefined or null",
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
		"keyExpectedValue": sprintf("gcp_container_cluster.master_auth.%s should be defined and not null", [field]),
		"keyActualValue": sprintf("gcp_container_cluster.master_auth.%s is undefined or null", [field]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["username", "password"]
	field := fields[f]

	field == ""

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_container_cluster.master_auth.%s should not be empty", [field]),
		"keyActualValue": sprintf("gcp_container_cluster.master_auth.%s is empty", [field]),
	}
}
