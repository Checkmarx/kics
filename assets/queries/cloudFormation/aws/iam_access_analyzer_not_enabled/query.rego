package Cx

import input as cf
import data.generic.common as common_lib

extensions := {".json", ".yaml"}

CxPolicy[result] {
	paths := [p |
		[path, value] := walk(cf)
		p := path
	]

	document_indexes := [nr |
		paths[x][0] == "document"
		paths[x][2] == "AWSTemplateFormatVersion"
		nr := paths[x][1]
	]

	not_defined(document_indexes)

	doc := input.document[document_indexes[0]]
    contains(doc.file, extensions[_])

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "Resources",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AWS::AccessAnalyzer::Analyzer' is set",
		"keyActualValue": "'AWS::AccessAnalyzer::Analyzer' is undefined",
		"searchLine": common_lib.build_search_line(["Resources"], []),
	}
}

not_defined(document_indexes) {
	count(document_indexes) != 0
	count({i | resources := input.document[i].Resources; resources[_].Type == "AWS::AccessAnalyzer::Analyzer"}) == 0
}

has_target(target) {
	contains(input.document[_].file, target)
}
