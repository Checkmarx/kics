package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.ip_allocation_policy
	not resource.networking_mode

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attributes 'ip_allocation_policy' and 'networking_mode' should be defined",
		"keyActualValue": "Attributes 'ip_allocation_policy' and 'networking_mode' are undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.ip_allocation_policy
	resource.networking_mode

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'ip_allocation_policy' should be defined",
		"keyActualValue": "Attribute 'ip_allocation_policy' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.ip_allocation_policy
	resource.networking_mode == "ROUTES"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'networking_mode' should be VPC_NATIVE",
		"keyActualValue": "Attribute 'networking_mode' is ROUTES",
	}
}
