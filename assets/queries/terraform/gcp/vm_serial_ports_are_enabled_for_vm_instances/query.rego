package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	compute := document.resource.google_compute_instance[name]
	metadata := compute.metadata

	serialPortEnabled(metadata)

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s].metadata.serial-port-enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.serial-port-enable should be set to false or undefined", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.serial-port-enable is true", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	project := document.resource.google_compute_project_metadata[name]
	metadata := project.metadata

	serialPortEnabled(metadata)

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_project_metadata",
		"resourceName": tf_lib.get_resource_name(project, name),
		"searchKey": sprintf("google_compute_project_metadata[%s].metadata.serial-port-enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_project_metadata[%s].metadata.serial-port-enable should be set to false or undefined", [name]),
		"keyActualValue": sprintf("google_compute_project_metadata[%s].metadata.serial-port-enable is true", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	metadata := document.resource.google_compute_project_metadata_item[name]
	metadata.key == "serial-port-enable"

	isTrue(metadata.value)

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_project_metadata_item",
		"resourceName": tf_lib.get_resource_name(metadata, name),
		"searchKey": sprintf("google_compute_project_metadata_item[%s].value", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_project_metadata[%s].value should be set to false", [name]),
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
