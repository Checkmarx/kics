package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	data := input.document[i].data.google_compute_instance[appserver]

	not common_lib.valid_key(data, "shielded_instance_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s]", [appserver]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'shielded_instance_config' is defined and not null",
		"keyActualValue": "Attribute 'shielded_instance_config' is undefined or null",
	}
}

CxPolicy[result] {
	data := input.document[i].data.google_compute_instance[appserver]
	fields := ["enable_secure_boot", "enable_vtpm", "enable_integrity_monitoring"]
	fieldTypes := fields[_]

	not common_lib.valid_key(data.shielded_instance_config, fieldTypes)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute 'shielded_instance_config.%s' is defined", [fieldTypes]),
		"keyActualValue": sprintf("Attribute 'shielded_instance_config.%s' is undefined", [fieldTypes]),
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
