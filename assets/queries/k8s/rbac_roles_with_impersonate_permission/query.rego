package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	kinds := {"Role", "ClusterRole"}
	document.kind in kinds

	"impersonate" in document.rules[j].verbs

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].verbs should not include the 'impersonate' verb", [metadata.name, j]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].verbs includes the 'impersonate' verb", [metadata.name, j]),
		"searchLine": common_lib.build_search_line(["rules", j], ["verbs"]),
	}
}
