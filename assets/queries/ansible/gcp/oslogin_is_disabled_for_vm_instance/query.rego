package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}
	instance := task[modules[m]]
	metadata := instance.metadata
	ansLib.checkState(instance)

	object.get(metadata, "enable-oslogin", "undefined") != "undefined"

	not ansLib.isAnsibleTrue(metadata["enable-oslogin"])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.metadata.enable-oslogin", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.metadata.enable-oslogin is true",
		"keyActualValue": "gcp_compute_instance.metadata.enable-oslogin is false",
	}
}
