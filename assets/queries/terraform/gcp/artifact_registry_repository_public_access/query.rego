package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

public_members := {"allUsers", "allAuthenticatedUsers"}

CxPolicy[result] {
	resource := input.document[i].resource.google_artifact_registry_repository_iam_member[name]
	resource.member == public_members[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_artifact_registry_repository_iam_member",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_artifact_registry_repository_iam_member[%s].member", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_artifact_registry_repository_iam_member[%s].member' should not be 'allUsers' or 'allAuthenticatedUsers'", [name]),
		"keyActualValue": sprintf("'google_artifact_registry_repository_iam_member[%s].member' is '%s'", [name, resource.member]),
		"searchLine": common_lib.build_search_line(["resource", "google_artifact_registry_repository_iam_member", name, "member"], []),
		"remediation": "Replace public member with a specific service account or group identity",
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_artifact_registry_repository_iam_binding[name]
	member := resource.members[_]
	member == public_members[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_artifact_registry_repository_iam_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_artifact_registry_repository_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_artifact_registry_repository_iam_binding[%s].members' should not include public identities", [name]),
		"keyActualValue": sprintf("'google_artifact_registry_repository_iam_binding[%s].members' contains '%s'", [name, member]),
		"searchLine": common_lib.build_search_line(["resource", "google_artifact_registry_repository_iam_binding", name, "members"], []),
		"remediation": "Remove public identities from members",
		"remediationType": "removal",
	}
}
