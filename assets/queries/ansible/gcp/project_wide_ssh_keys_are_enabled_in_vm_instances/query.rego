package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(input.document[i])[t]
	instance := task["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	ansLib.checkState(instance)
	object.get(metadata, "block-project-ssh-keys", "undefined") != "undefined"
	not ansLib.isAnsibleTrue(object.get(metadata, "block-project-ssh-keys", "undefined"))

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is true", [task.name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is false", [task.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(input.document[i])[t]
	instance := task["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	ansLib.checkState(instance)
	object.get(metadata, "block-project-ssh-keys", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is set and is true", [task.name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is undefined", [task.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(input.document[i])[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	object.get(instance, "metadata", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata' is set", [task.name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata' is undefined", [task.name]),
	}
}
