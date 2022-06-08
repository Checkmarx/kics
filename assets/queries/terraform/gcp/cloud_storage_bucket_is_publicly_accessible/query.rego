package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	iam_member := input.document[i].resource.google_storage_bucket_iam_member[name]
	public_access_users := ["allUsers", "allAuthenticatedUsers"]

	not iam_member.members
	some j
	public_access_users[j] == iam_member.member

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket_iam_member",
		"resourceName": tf_lib.get_resource_name(iam_member, name),
		"searchKey": sprintf("google_storage_bucket_iam_member[%s].member", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'member' not equal to 'allUsers' nor 'allAuthenticatedUsers'",
		"keyActualValue": sprintf("'member' equal to '%s'", [iam_member.member]),
	}
}

CxPolicy[result] {
	iam_member := input.document[i].resource.google_storage_bucket_iam_member[name]
	public_access_users := ["allUsers", "allAuthenticatedUsers"]

	some j, k
	public_access_users[j] == iam_member.members[k]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket_iam_member",
		"resourceName": tf_lib.get_resource_name(iam_member, name),
		"searchKey": sprintf("google_storage_bucket_iam_member[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "None of the 'members' equal to 'allUsers' nor 'allAuthenticatedUsers'",
		"keyActualValue": "One of the 'members' equal to 'allUsers' or 'allAuthenticatedUsers'",
	}
}
