package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[primary]
	resource.monitoring_service == "none"

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].monitoring_service", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'monitoring_service' should be undefined or 'monitoring.googleapis.com/kubernetes'",
		"keyActualValue": "Attribute 'monitoring_service' is 'none'",
	}
}

# Legacy Stackdriver was decomissioned Mar 31, 2021
CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[primary]
	resource.monitoring_service == "monitoring.googleapis.com"

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].monitoring_service", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'monitoring_service' should be undefined or 'monitoring.googleapis.com/kubernetes'",
		"keyActualValue": "Attribute 'monitoring_service' is 'monitoring.googleapis.com'",
	}
}
