package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	metadata := compute.metadata
	oslogin := object.get(metadata, "enable-oslogin", "undefined")
	isFalse(oslogin)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s].metadata.enable-oslogin", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.enable-oslogin should be true or undefined", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.enable-oslogin is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name],["metadata", "enable-oslogin"]),
		"remediation": json.marshal({
			"before": sprintf("%s", [oslogin]),
			"after": "true"
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
