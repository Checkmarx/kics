package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	ansLib.isAnsibleTrue(instance.metadata["serial-port-enable"])

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.metadata.serial-port-enable", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.metadata.serial-port-enable should be undefined or set to false",
		"keyActualValue": "gcp_compute_instance.metadata.serial-port-enable is set to true",
	}
}
