package Cx

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	metadata := compute.metadata

	serialPortEnabled(metadata)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].metadata.serial-port-enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.serial-port-enable is false or undefined", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.serial-port-enable is true", [name]),
	}
}

CxPolicy[result] {
	project := input.document[i].resource.google_compute_project_metadata[name]
	metadata := project.metadata

	serialPortEnabled(metadata)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_project_metadata[%s].metadata.serial-port-enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_project_metadata[%s].metadata.serial-port-enable is false or undefined", [name]),
		"keyActualValue": sprintf("google_compute_project_metadata[%s].metadata.serial-port-enable is true", [name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].resource.google_compute_project_metadata_item[name]
	metadata.key == "serial-port-enable"

	isTrue(metadata.value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_project_metadata_item[%s].value", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_project_metadata[%s].value is false", [name]),
		"keyActualValue": sprintf("google_compute_project_metadata[%s].value is true", [name]),
	}
}

serialPortEnabled(metadata) {
	serial_enabled := object.get(metadata, "serial-port-enable", "undefined")
	isTrue(serial_enabled)
}

isTrue(value) {
	is_string(value)
	lower(value) == "true"
}

isTrue(value) {
	is_boolean(value)
	value
}
