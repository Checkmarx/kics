package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}
	compute_instance := task[modules[m]]
	ansLib.checkState(compute_instance)

	compute_instance.network_interfaces[_].access_configs

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_interfaces.access_configs", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.network_interfaces.access_configs should not be defined",
		"keyActualValue": "gcp_compute_instance.network_interfaces.access_configs is defined",
	}
}
