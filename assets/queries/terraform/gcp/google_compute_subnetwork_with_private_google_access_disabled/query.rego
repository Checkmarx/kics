package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_subnetwork[name]
	not common_lib.valid_key(resource, "private_ip_google_access")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_subnetwork",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_subnetwork[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_subnetwork[%s].private_ip_google_access' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_subnetwork[%s].private_ip_google_access' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_subnetwork", name], []),
		"remediation": "private_ip_google_access = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_subnetwork[name]
	resource.private_ip_google_access == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_subnetwork",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_subnetwork[%s].private_ip_google_access", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_subnetwork[%s].private_ip_google_access' should be set to true", [name]),
		"keyActualValue": sprintf("'google_compute_subnetwork[%s].private_ip_google_access' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_subnetwork", name, "private_ip_google_access"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
