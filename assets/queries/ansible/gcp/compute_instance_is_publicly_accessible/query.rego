package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	compute_instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(compute_instance)
	compute_instance.network_interfaces[_].access_configs

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.network_interfaces.access_configs", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.network_interfaces.access_configs is not defined",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.network_interfaces.access_configs is defined",
	}
}
