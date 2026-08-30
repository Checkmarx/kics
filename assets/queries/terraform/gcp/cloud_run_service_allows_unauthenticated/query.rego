package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_cloud_run_service_iam_member[name]
	resource.member == "allUsers"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_service_iam_member",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_cloud_run_service_iam_member[%s].member", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_cloud_run_service_iam_member[%s].member' should not be 'allUsers'", [name]),
		"keyActualValue": sprintf("'google_cloud_run_service_iam_member[%s].member' is 'allUsers', allowing unauthenticated access", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_service_iam_member", name, "member"], []),
		"remediation": "Remove 'allUsers' member and use specific service accounts or authenticated identities",
		"remediationType": "removal",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_cloud_run_service_iam_binding[name]
	resource.members[_] == "allUsers"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_service_iam_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_cloud_run_service_iam_binding[%s].members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_cloud_run_service_iam_binding[%s].members' should not contain 'allUsers'", [name]),
		"keyActualValue": sprintf("'google_cloud_run_service_iam_binding[%s].members' contains 'allUsers', allowing unauthenticated access", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_service_iam_binding", name, "members"], []),
		"remediation": "Remove 'allUsers' from members and use specific authenticated identities",
		"remediationType": "removal",
	}
}
