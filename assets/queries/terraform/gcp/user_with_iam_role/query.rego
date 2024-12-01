package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

options := {"user:", "allUsers", "allAuthenticatedUsers"}

CxPolicy[result] {
	some document in input.document
	resource := document.data.google_iam_policy[name]

	tf_lib.check_member(resource.binding, options[_])
	common_lib.valid_key(resource.binding, "role")

	result := {
		"documentId": document.id,
		"resourceType": "google_iam_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_iam_policy[%s].binding.role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_iam_policy[%s].binding.role should not be set", [name]),
		"keyActualValue": sprintf("google_iam_policy[%s].binding.role is set", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_iam_policy", name, "binding", "role"], []),
	}
}

CxPolicy[result] {
	resources := {"google_project_iam_binding", "google_project_iam_member"}
	some document in input.document
	resource := document.resource[resources[idx]][name]

	tf_lib.check_member(resource, options[_])
	common_lib.valid_key(resource, "role")

	result := {
		"documentId": document.id,
		"resourceType": resources[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].role", [resources[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].role should not be set", [resources[idx], name]),
		"keyActualValue": sprintf("%s[%s].role is set", [resources[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[idx], name, "role"], []),
	}
}
