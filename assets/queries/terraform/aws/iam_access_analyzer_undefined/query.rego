package Cx

import input as tf
import data.generic.common as common_lib

CxPolicy[result] {
	paths := [p |
		[path, value] := walk(tf)
		p := path
	]

	document_indexes := [nr |
		count(paths[x]) == 3
		paths[x][0] == "document"
		paths[x][2] == "resource"
		nr := paths[x][1]
	]

	not_defined(document_indexes)

	doc := input.document[document_indexes[0]]
    contains(doc.file, ".tf")

	result := {
		"documentId": doc.id,
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_accessanalyzer_analyzer' is set",
		"keyActualValue": "'aws_accessanalyzer_analyzer' is undefined",
		"searchLine": common_lib.build_search_line(["resource"], []),
	}
}

not_defined(document_indexes) {
	count(document_indexes) != 0
	count({x | resource := input.document[x].resource; object.get(resource, "aws_accessanalyzer_analyzer", "undefined") != "undefined"}) == 0
}
