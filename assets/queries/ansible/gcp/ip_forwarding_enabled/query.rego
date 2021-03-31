package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	ansLib.isAnsibleTrue(instance.can_ip_forward)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.can_ip_forward", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.can_ip_forward is false",
		"keyActualValue": "gcp_compute_instance.can_ip_forward is true",
	}
}
