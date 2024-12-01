package Cx

import data.generic.common as common_lib
import input as cf
import future.keywords.in

extensions := {".json", ".yaml"}

CxPolicy[result] {
	some doc in input.document
	resources := doc.Resources
	count(resources) > 0
	count({i | resources[_].Type == "AWS::AccessAnalyzer::Analyzer"}) == 0

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "Resources",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AWS::AccessAnalyzer::Analyzer' should be set",
		"keyActualValue": "'AWS::AccessAnalyzer::Analyzer' is undefined",
		"searchLine": common_lib.build_search_line(["Resources"], []),
	}
}
