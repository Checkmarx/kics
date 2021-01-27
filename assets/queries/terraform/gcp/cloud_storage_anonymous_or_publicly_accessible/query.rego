package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket_iam_binding[name]
	resource.members == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_storage_bucket_iam_binding[%s].members' is not null", [name]),
		"keyActualValue": sprintf("'google_storage_bucket_iam_binding[%s].members' is null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket_iam_binding[name]
	member := resource.members[_]
	contains(member, "allUsers")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_storage_bucket_iam_binding[%s].members' does not have 'allUsers'", [name]),
		"keyActualValue": sprintf("'google_storage_bucket_iam_binding[%s].members' has 'allUsers'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket_iam_binding[name]
	member := resource.members[_]
	contains(member, "allAuthenticatedUsers")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_storage_bucket_iam_binding[%s].members' does not have 'allAuthenticatedUsers'", [name]),
		"keyActualValue": sprintf("'google_storage_bucket_iam_binding[%s].members' has 'allAuthenticatedUsers'", [name]),
	}
}
