package Cx

import input as tf
import data.generic.common as common_lib

CxPolicy[result] {
	paths := [p |
		[path, _] := walk(tf)
		p := path
	]

	document_indexes := [nr |
		count(paths[x]) == 3
		paths[x][0] == "document"
		paths[x][2] == "resource"
		nr := paths[x][1]
	]

	not_defined(document_indexes)

	indexes := document_indexes[i]
	doc := input.document[indexes]
	contains(doc.file, ".tf")

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_accessanalyzer_analyzer' should be set",
		"keyActualValue": "'aws_accessanalyzer_analyzer' is undefined",
		"searchLine": common_lib.build_search_line(["resource"], []),
	}
}

not_defined(document_indexes) {
	count(document_indexes) != 0
	count({name | input.document[x].resource[name]; contains(name, "aws")}) > 0
	count({x | resource := input.document[x].resource; common_lib.valid_key(resource, "aws_accessanalyzer_analyzer")}) == 0
}
