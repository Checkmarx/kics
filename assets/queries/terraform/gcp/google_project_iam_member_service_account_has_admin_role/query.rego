package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountAdmin")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should not be admin", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is admin", [name]),
	}
}

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	inArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountAdmin")

	result := {
		"documentId": input.document[i].id,
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
