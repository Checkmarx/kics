package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	member := document.resources[resource].accessControl.gcpIamPolicy.bindings[binding].members[memberIndex]
	startswith(member, "user:")
	endswith(member, "gmail.com")

	result := {
		"documentId": document.id,
		"resourceType": document.resources[resource].type,
		"resourceName": document.resources[resource].name,
		"searchKey": sprintf("accessControl.gcpIamPolicy.bindings[%s].members.%s", [binding, member]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'members' cannot contain Gmail account addresses",
		"keyActualValue": sprintf("'members' has email address: %s", [member]),
		"searchLine": common_lib.build_search_line(["resources", resource, "accessControl", "gcpIamPolicy", "bindings", binding, "members"], []),
	}
}
