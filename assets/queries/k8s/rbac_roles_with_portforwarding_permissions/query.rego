package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	document := input.document[i]

	kinds := {"Role", "ClusterRole"}
	document.kind in kinds
	"pods/portforward" in document.rules[j].resources

	verbs := {"update", "patch", "create", "*"}
	document.rules[j].verbs[_] == verbs[_]

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].resources should not include the 'pods/portforward' resource", [metadata.name, j]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].resources includes the 'pods/portforward' resource", [metadata.name, j]),
		"searchLine": common_lib.build_search_line(["rules", j], ["resources"]),
	}
}
