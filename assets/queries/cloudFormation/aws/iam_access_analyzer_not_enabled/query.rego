package Cx

import input as cf
import data.generic.common as common_lib

extensions := {".json", ".yaml"}

CxPolicy[result] {

	resources := input.document[i].Resources;
	count(resources) > 0
	count({i | resources[_].Type == "AWS::AccessAnalyzer::Analyzer"}) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "Resources",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AWS::AccessAnalyzer::Analyzer' should be set",
		"keyActualValue": "'AWS::AccessAnalyzer::Analyzer' is undefined",
		"searchLine": common_lib.build_search_line(["Resources"], []),
	}	
}