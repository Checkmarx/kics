package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

options := {"user:", "allUsers", "allAuthenticatedUsers"}

CxPolicy[result] {
	resource := input.document[i].data.google_iam_policy[name]

	terra_lib.check_member(resource.binding, options[_])
	common_lib.valid_key(resource.binding, "role")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_iam_policy[%s].binding.role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_iam_policy[%s].binding.role is not set", [name]),
		"keyActualValue": sprintf("google_iam_policy[%s].binding.role is set", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_iam_policy", name, "binding", "role"], []),
	}
}

CxPolicy[result] {
	resources := {"google_project_iam_binding", "google_project_iam_member"}
	resource := input.document[i].resource[resources[idx]][name]

	terra_lib.check_member(resource, options[_])
	common_lib.valid_key(resource, "role")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].role", [resources[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].role is not set", [resources[idx], name]),
		"keyActualValue": sprintf("%s[%s].role is set", [resources[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[idx], name, "role"], [])
	}
}
