package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_subnetwork[name]
	not common_lib.valid_key(resource, "log_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_subnetwork[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_subnetwork[%s].log_config' is defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_subnetwork[%s].log_config' is undefined or null", [name]),
	}
}
