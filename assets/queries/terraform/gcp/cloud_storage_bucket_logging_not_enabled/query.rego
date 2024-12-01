package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_storage_bucket[name]
	not common_lib.valid_key(resource, "logging")

	result := {
		"documentId": document.id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'google_storage_bucket.logging' should be set",
		"keyActualValue": "'google_storage_bucket.logging' is undefined",
	}
}
