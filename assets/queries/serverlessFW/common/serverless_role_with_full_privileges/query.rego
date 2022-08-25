package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	iam := document.provider.iam
	statement := iam.role.statements[stt]
	check_policy(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("iam", document.provider.name),
		"resourceName": iam.role.name,
		"searchKey": sprintf("provider.iam.role.statements[%d]", [stt]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Statement should not give admin privileges",
		"keyActualValue": "Statement gives admin privileges",
		"searchLine": common_lib.build_search_line(["provider", "iam", "role", "statements", stt], []),
	}
}

check_policy(statement) {
	common_lib.is_allow_effect(statement)
	common_lib.containsOrInArrayContains(statement.Resource, "*")
	common_lib.containsOrInArrayContains(statement.Action, "*")
}
