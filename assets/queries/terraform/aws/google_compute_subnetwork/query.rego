package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_subnetwork[name]
	object.get(resource, "log_config", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_subnetwork[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_subnetwork[%s].log_config' is defined", [name]),
		"keyActualValue": sprintf("'google_compute_subnetwork[%s].log_config' is undefined", [name]),
	}
}
