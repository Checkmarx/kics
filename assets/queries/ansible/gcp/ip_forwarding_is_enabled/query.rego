package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	ansLib.isAnsibleTrue(instance.can_ip_forward)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.can_ip_forward", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.can_ip_forward is false",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.can_ip_forward is true",
	}
}
