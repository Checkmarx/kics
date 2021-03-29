package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster, "master_auth", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.master_auth is defined",
		"keyActualValue": "gcp_container_cluster.master_auth is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["username", "password"]

	object.get(cluster.master_auth, fields[f], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("gcp_container_cluster.master_auth.%s is defined", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.master_auth.%s is undefined", [fields[f]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)
	fields := ["username", "password"]

	commonLib.emptyOrNull(cluster.master_auth[fields[f]])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_container_cluster.master_auth.%s is not empty", [fields[f]]),
		"keyActualValue": sprintf("gcp_container_cluster.master_auth.%s is empty", [fields[f]]),
	}
}
