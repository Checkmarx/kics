package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].data.google_iam_policy[name]

	tf_lib.check_member(resource.binding, "serviceAccount:")
	has_improperly_privileges(resource.binding.role)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_iam_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_iam_policy[%s].binding.role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_iam_policy[%s].binding.role should not have admin, editor, owner, or write privileges for service account member", [name]),
		"keyActualValue": sprintf("google_iam_policy[%s].binding.role has admin, editor, owner, or write privilege for service account member", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_iam_policy", name, "binding", "role"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].data.google_iam_policy[name]

	tf_lib.check_member(resource.binding[x], "serviceAccount:")
	has_improperly_privileges(resource.binding[x].role)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_iam_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_iam_policy[%s].binding[%s].role", [name, format_int(x, 10)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_iam_policy[%s].binding[%s].role should not have admin, editor, owner, or write privileges for service account member", [name, format_int(x, 10)]),
		"keyActualValue": sprintf("google_iam_policy[%s].binding[%s].role has admin, editor, owner, or write privilege for service account member", [name, format_int(x, 10)]),
		"searchLine": common_lib.build_search_line(["data", "google_iam_policy", name, "binding", x, "role"], []),
	}
}

CxPolicy[result] {
	resources := {"google_project_iam_binding", "google_project_iam_member"}
	resource := input.document[i].resource[resources[idx]][name]

	tf_lib.check_member(resource, "serviceAccount:")
	has_improperly_privileges(resource.role)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].role", [resources[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].role should not have admin, editor, owner, or write privileges for service account member", [resources[idx], name]),
		"keyActualValue": sprintf("%s[%s].role has admin, editor, owner, or write privilege for service account member", [resources[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[idx], name, "role"], []),
	}
}

has_improperly_privileges(role) {
	privileges := {"admin", "owner", "editor"}
	contains(lower(role), privileges[x])
}
