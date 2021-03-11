package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	ansLib.checkState(instance)
	object.get(metadata, "enable-oslogin", "undefined") != "undefined"

	not ansLib.isAnsibleTrue(metadata["enable-oslogin"])

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin' is true", [task.name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin' is false", [task.name]),
	}
}
