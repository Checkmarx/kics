package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[primary]
	resource.enable_legacy_abac == true

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].enable_legacy_abac", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'enable_legacy_abac' should be set to false",
		"keyActualValue": "Attribute 'enable_legacy_abac' is true",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary], ["enable_legacy_abac"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
