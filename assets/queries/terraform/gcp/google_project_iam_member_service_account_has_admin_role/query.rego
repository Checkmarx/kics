package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	projectIam := document.resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountAdmin")

	result := {
		"documentId": document.id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should not be admin", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is admin", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	projectIam := document.resource.google_project_iam_member[name]
	inArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountAdmin")

	result := {
		"documentId": document.id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should not be admin", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is admin", [name]),
	}
}

inArray(array, elem) {
	startswith(array[_], elem)
}
