package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]

	not common_lib.valid_key(resource, "versioning")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' should be defined and not null",
		"keyActualValue": "'versioning' it undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_storage_bucket", name],[]),
		"remediation": "versioning {\n\t\tenabled = true\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]

	resource.versioning.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket[%s].versioning.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.enabled' should be true",
		"keyActualValue": "'versioning.enabled' is false",
		"searchLine": common_lib.build_search_line(["resource", "google_storage_bucket", name],["versioning", "enabled"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
