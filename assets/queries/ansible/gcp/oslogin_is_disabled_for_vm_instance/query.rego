package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}
	instance := task[modules[m]]
	metadata := instance.metadata
	ansLib.checkState(instance)

	common_lib.valid_key(metadata, "enable-oslogin")

	not ansLib.isAnsibleTrue(metadata["enable-oslogin"])

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.metadata.enable-oslogin", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.metadata.enable-oslogin should be true",
		"keyActualValue": "gcp_compute_instance.metadata.enable-oslogin is false",
	}
}
