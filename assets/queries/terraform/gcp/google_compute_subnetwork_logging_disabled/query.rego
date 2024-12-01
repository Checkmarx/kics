package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_compute_subnetwork[name]
	not common_lib.valid_key(resource, "log_config")

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_subnetwork",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_subnetwork[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_subnetwork[%s].log_config' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_subnetwork[%s].log_config' is undefined or null", [name]),
	}
}
