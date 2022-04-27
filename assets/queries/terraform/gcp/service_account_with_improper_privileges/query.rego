package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].data.google_iam_policy[name]

	terra_lib.check_member(resource.binding, "serviceAccount:")
	has_improperly_privileges(resource.binding.role)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_iam_policy[%s].binding.role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_iam_policy[%s].binding.role does not have admin, editor, owner, or write privileges for service account member", [name]),
		"keyActualValue": sprintf("google_iam_policy[%s].binding.role has admin, editor, owner, or write privilege for service account member", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_iam_policy", name, "binding", "role"], []),
	}
}

CxPolicy[result] {
	resources := {"google_project_iam_binding", "google_project_iam_member"}
	resource := input.document[i].resource[resources[idx]][name]

	terra_lib.check_member(resource, "serviceAccount:")
	has_improperly_privileges(resource.role)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].role", [resources[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].role does not have admin, editor, owner, or write privileges for service account member", [resources[idx], name]),
		"keyActualValue": sprintf("%s[%s].role has admin, editor, owner, or write privilege for service account member", [resources[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[idx], name, "role"], []),
	}
}

has_improperly_privileges(role) {
	privileges := {"admin", "owner", "editor"}
	contains(lower(role), privileges[x])
}
