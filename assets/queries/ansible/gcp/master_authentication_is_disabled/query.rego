package Cx

import data.generic.ansible as ansLib

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

	object.get(cluster.master_auth, "username", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.master_auth.username is defined",
		"keyActualValue": "gcp_container_cluster.master_auth.username is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	object.get(cluster.master_auth, "password", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_container_cluster.master_auth.password is defined",
		"keyActualValue": "gcp_container_cluster.master_auth.password is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	ansLib.checkValue(cluster.master_auth.username)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth.username", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.master_auth.username is not empty",
		"keyActualValue": "gcp_container_cluster.master_auth.username is empty",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task[modules[m]]
	ansLib.checkState(cluster)

	ansLib.checkValue(cluster.master_auth.password)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.master_auth.password", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_container_cluster.master_auth.password is not empty",
		"keyActualValue": "gcp_container_cluster.master_auth.password is empty",
	}
}
