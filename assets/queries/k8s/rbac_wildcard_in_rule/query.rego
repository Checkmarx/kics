package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	kinds := {"Role", "ClusterRole"}
	document.kind == kinds[_]

	attr := {"apiGroups", "resources", "verbs"}
	common_lib.valid_key(document.rules[j], attr[k])

	document.rules[j][k][_] == "*"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].%s should list the minimal set of needed objects or actions", [metadata.name, j, k]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].%s uses wildcards to specify objects or actions", [metadata.name, j, k]),
		"searchLine": common_lib.build_search_line(["rules", j], [k])
	}
}
