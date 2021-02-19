package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	object.get(instance, "shielded_instance_config", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.shielded_instance_config
	object.get(instance.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_integrity_monitoring is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_integrity_monitoring is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.shielded_instance_config
	object.get(instance.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_secure_boot is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_secure_boot is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.shielded_instance_config
	object.get(instance.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_vtpm is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_vtpm is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	ansLib.isAnsibleFalse(instance.shielded_instance_config.enable_integrity_monitoring)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_integrity_monitoring", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_integrity_monitoring is true",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_integrity_monitoring is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	ansLib.isAnsibleFalse(instance.shielded_instance_config.enable_secure_boot)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_secure_boot", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_secure_boot is true",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_secure_boot is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	ansLib.isAnsibleFalse(instance.shielded_instance_config.enable_vtpm)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_vtpm", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_vtpm is true",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_vtpm is false",
	}
}
