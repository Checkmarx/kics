package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	ansLib.checkState(instance)
	object.get(metadata, "enable-oslogin", "undefined") != "undefined"

	not ansLib.isAnsibleTrue(object.get(metadata, "enable-oslogin", "undefined"))

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin' is true", [task.name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin' is false", [task.name]),
	}
}
