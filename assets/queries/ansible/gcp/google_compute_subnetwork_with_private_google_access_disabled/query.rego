package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_compute_subnetwork", "gcp_compute_subnetwork"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	subnetwork := task[modules[m]]
	ans_lib.checkState(subnetwork)

	not common_lib.valid_key(subnetwork, "private_ip_google_access")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.private_ip_google_access is defined and not null", [modules[m]]),
		"keyActualValue": sprintf("%s.private_ip_google_access is undefined or null", [modules[m]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m]], []),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	subnetwork := task[modules[m]]
	ans_lib.checkState(subnetwork)

	subnetwork.private_ip_google_access != "yes"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.private_ip_google_access", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "%s.private_ip_google_access is set to true",
		"keyActualValue": "%s.private_ip_google_access is set to false",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "private_ip_google_access"], []),
	}
}
