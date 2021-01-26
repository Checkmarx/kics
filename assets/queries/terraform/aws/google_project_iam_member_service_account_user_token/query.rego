package Cx

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountTokenCreator")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role is Service Account Token Creator", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account Token Creator", [name]),
	}
}

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	containsArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountTokenCreator")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role is Service Account Token Creator", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account Token Creator", [name]),
	}
}

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountUser")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role is Service Account User", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account User", [name]),
	}
}

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	containsArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountUser")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role is Service Account User", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is not Service Account User", [name]),
	}
}

containsArray(array, elem) {
	startswith(array[_], elem)
} else = false {
	true
}
