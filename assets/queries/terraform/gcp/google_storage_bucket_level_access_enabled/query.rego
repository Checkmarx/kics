package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	storageBucket := input.document[i].resource.google_storage_bucket[name]
	storageBucket.uniform_bucket_level_access == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket[%s].uniform_bucket_level_access", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is true", [name]),
		"keyActualValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is false", [name]),
	}
}

CxPolicy[result] {
	storageBucket := input.document[i].resource.google_storage_bucket[name]
	not common_lib.valid_key(storageBucket, "uniform_bucket_level_access")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is defined and not null", [name]),
		"keyActualValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is undefined or null", [name]),
	}
}
