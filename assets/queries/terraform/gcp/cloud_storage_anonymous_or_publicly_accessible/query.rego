package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket_iam_binding[name]
	count(resource.members) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket_iam_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_storage_bucket_iam_binding[%s].members' should not be null", [name]),
		"keyActualValue": sprintf("'google_storage_bucket_iam_binding[%s].members' is null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket_iam_binding[name]
	member := resource.members[_]
	contains(member, "allUsers")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket_iam_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_storage_bucket_iam_binding[%s].members' should not have 'allUsers'", [name]),
		"keyActualValue": sprintf("'google_storage_bucket_iam_binding[%s].members' has 'allUsers'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket_iam_binding[name]
	member := resource.members[_]
	contains(member, "allAuthenticatedUsers")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket_iam_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_storage_bucket_iam_binding[%s].members' should not have 'allAuthenticatedUsers'", [name]),
		"keyActualValue": sprintf("'google_storage_bucket_iam_binding[%s].members' has 'allAuthenticatedUsers'", [name]),
	}
}
