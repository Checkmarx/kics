package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.logging_service

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'logging_service' should be defined",
		"keyActualValue": "Attribute 'logging_service' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.logging_service == "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'logging_service' should not be 'none'",
		"keyActualValue": "Attribute 'logging_service' is 'none'",
	}
}
