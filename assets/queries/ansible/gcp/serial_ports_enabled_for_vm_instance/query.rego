package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	ansLib.checkState(instance)
	ansLib.isAnsibleTrue(object.get(metadata, "serial-port-enable", "undefined"))

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.serial-port-enable", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.serial-port-enable' is undefined or set to false", [task.name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.serial-port-enable' is set to true", [task.name]),
	}
}
