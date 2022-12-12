package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	kinds := {"Role", "ClusterRole"}
	document.kind == kinds[_]

	verbs := {"bind", "escalate", "*"}
	resources := {"roles", "clusterroles"}
	document.rules[j].resources[_] == resources[_]
	document.rules[j].verbs[_] == verbs[_]

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].verbs should not include the 'bind' and/or 'escalate' permission", [metadata.name, j]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].verbs includes the 'bind' and/or 'escalate' permission", [metadata.name, j]),
		"searchLine": common_lib.build_search_line(["rules", j], ["verbs"])
	}
}
