package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_container_cluster", "gcp_container_cluster"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task[modules[m]]
	ansLib.checkState(container_cluster)

	not common_lib.valid_key(container_cluster.node_config, "service_account")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.node_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'service_account' should not be default",
		"keyActualValue": "'service_account' is missing",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "node_config"], []),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	container_cluster := task[modules[m]]
	ansLib.checkState(container_cluster)

	contains(container_cluster.node_config.service_account, "default")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.node_config.service_account", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account' should not be default",
		"keyActualValue": "'service_account' is default",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "node_config", "service_account"], []),
	}
}
