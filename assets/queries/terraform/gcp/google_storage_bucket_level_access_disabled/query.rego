package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	storageBucket := input.document[i].resource.google_storage_bucket[name]
	storageBucket.uniform_bucket_level_access == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(storageBucket, name),
		"searchKey": sprintf("google_storage_bucket[%s].uniform_bucket_level_access", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access should be true", [name]),
		"keyActualValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_storage_bucket", name, "uniform_bucket_level_access"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	storageBucket := input.document[i].resource.google_storage_bucket[name]
	not common_lib.valid_key(storageBucket, "uniform_bucket_level_access")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(storageBucket, name),
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access should be defined and not null", [name]),
		"keyActualValue": sprintf("google_storage_bucket[%s].uniform_bucket_level_access is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_storage_bucket", name], []),
		"remediation": "uniform_bucket_level_access = true",
		"remediationType": "addition",
	}
}
