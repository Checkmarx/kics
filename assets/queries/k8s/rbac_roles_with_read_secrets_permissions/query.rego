package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	document := input.document[i]

	kinds := {"Role", "ClusterRole"}
	document.kind in kinds

	"secrets" in document.rules[j].resources
	readVerbs := {"get", "watch", "list"}
	document.rules[j].verbs[_] == readVerbs[_]

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d] should not be granted read access to Secrets objects", [metadata.name, j]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d] is granted read access (verbs: %v) to Secrets objects", [metadata.name, j, concat(", ", document.rules[j].verbs)]),
		"searchLine": common_lib.build_search_line(["rules", j], ["verbs"]),
	}
}
