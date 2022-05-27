package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_project_metadata[name].metadata
	resource["enable-oslogin"] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_project_metadata",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_compute_project_metadata[name], name),
		"searchKey": sprintf("google_compute_project_metadata[%s].metadata", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_project_metadata[%s].metadata['enable-oslogin'] is true", [name]),
		"keyActualValue": sprintf("google_compute_project_metadata[%s].metadata['enable-oslogin'] is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_project_metadata[name].metadata
	not common_lib.valid_key(resource, "enable-oslogin")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_project_metadata",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_compute_project_metadata[name], name),
		"searchKey": sprintf("google_compute_project_metadata[%s].metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_project_metadata[%s].metadata['enable-oslogin'] is true", [name]),
		"keyActualValue": sprintf("google_compute_project_metadata[%s].metadata['enable-oslogin'] is undefined", [name]),
	}
}
