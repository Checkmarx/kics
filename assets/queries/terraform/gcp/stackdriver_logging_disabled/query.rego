package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[primary]
	resource.logging_service == "none"

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].logging_service", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'logging_service' should be undefined or 'logging.googleapis.com/kubernetes'",
		"keyActualValue": "Attribute 'logging_service' is 'none'",
	}
}

# legacy stackdriver was decomissioned Mar 31, 2021 https://cloud.google.com/stackdriver/docs/deprecations/legacy
CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[primary]
	resource.logging_service == "logging.googleapis.com"

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].logging_service", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'logging_service' should be undefined or 'logging.googleapis.com/kubernetes'",
		"keyActualValue": "Attribute 'logging_service' is 'logging.googleapis.com'",
	}
}
