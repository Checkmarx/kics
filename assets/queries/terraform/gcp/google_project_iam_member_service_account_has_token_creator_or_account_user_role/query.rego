package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	projectIam := document.resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountTokenCreator")

	result := {
		"documentId": document.id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should be Service Account Token Creator", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account Token Creator", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	projectIam := document.resource.google_project_iam_member[name]
	containsArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountTokenCreator")

	result := {
		"documentId": document.id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should be Service Account Token Creator", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account Token Creator", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	projectIam := document.resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountUser")

	result := {
		"documentId": document.id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should be Service Account User", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account User", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	projectIam := document.resource.google_project_iam_member[name]
	containsArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountUser")

	result := {
		"documentId": document.id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should be Service Account User", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account User", [name]),
	}
}

containsArray(array, elem) {
	startswith(array[_], elem)
} else = false
