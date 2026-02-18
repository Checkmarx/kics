package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	count({x | doc.resource[name]; startswith(name, "aws_"); x := name}) > 0

	not common_lib.valid_key(doc.resource, "aws_accessanalyzer_analyzer")

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
