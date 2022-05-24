package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	member := input.document[i].resources[resource].accessControl.gcpIamPolicy.bindings[binding].members[memberIndex]
	startswith(member, "user:")
	endswith(member, "gmail.com")

	result := {
		"documentId": input.document[i].id,
		"resourceType": input.document[i].resources[resource].type,
		"resourceName": input.document[i].resources[resource].name,
		"searchKey": sprintf("accessControl.gcpIamPolicy.bindings[%s].members.%s", [binding, member]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'members' cannot contain Gmail account addresses",
		"keyActualValue": sprintf("'members' has email address: %s", [member]),
		"searchLine": common_lib.build_search_line(["resources", resource, "accessControl", "gcpIamPolicy", "bindings", binding, "members"], []),
	}
}
