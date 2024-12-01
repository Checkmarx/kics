package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	compute := document.resource.google_compute_instance[name]
	metadata := compute.metadata
	oslogin := object.get(metadata, "enable-oslogin", "undefined")
	isFalse(oslogin)

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s].metadata.enable-oslogin", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.enable-oslogin should be true or undefined", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.enable-oslogin is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name], ["metadata", "enable-oslogin"]),
		"remediation": json.marshal({
			"before": sprintf("%s", [oslogin]),
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

isFalse(value) {
	is_string(value)
	lower(value) == "false"
}

isFalse(value) {
	is_boolean(value)
	not value
}
