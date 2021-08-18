package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]
	not common_lib.valid_key(resource,"logging")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'google_storage_bucket.logging' is set",
		"keyActualValue": "'google_storage_bucket.logging' is undefined",
	}
}
