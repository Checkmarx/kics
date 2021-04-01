package Cx

CxPolicy[result] {
	data := input.document[i].data.google_compute_instance[appserver]

	object.get(data, "shielded_instance_config", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s]", [appserver]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'shielded_instance_config' is defined",
		"keyActualValue": "Attribute 'shielded_instance_config' is undefined",
	}
}

CxPolicy[result] {
	data := input.document[i].data.google_compute_instance[appserver]
	fields := ["enable_secure_boot", "enable_vtpm", "enable_integrity_monitoring"]

	object.get(data.shielded_instance_config, fields[j], "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute 'shielded_instance_config.%s' is defined", [fields[j]]),
		"keyActualValue": sprintf("Attribute 'shielded_instance_config.%s' is undefined", [fields[j]]),
	}
}

CxPolicy[result] {
	data := input.document[i].data.google_compute_instance[appserver]
	fields := ["enable_secure_boot", "enable_vtpm", "enable_integrity_monitoring"]

	data.shielded_instance_config[fields[j]] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].shielded_instance_config.%s", [appserver, fields[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Attribute 'shielded_instance_config.%s' is true", [fields[j]]),
		"keyActualValue": sprintf("Attribute 'shielded_instance_config.%s' is false", [fields[j]]),
	}
}
