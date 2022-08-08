package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	function := functions[fname]
	tracing := function.tracing
	tracing != "Active"

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions.%s.tracing", [fname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'tracing' should be set to Active",
		"keyActualValue": "'tracing' is not set to Active",
		"searchLine": common_lib.build_search_line(["functions", fname, "tracing"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	function := functions[fname]

	not common_lib.valid_key(function, "tracing")

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions.%s", [fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'tracing' should be defined and set to Active",
		"keyActualValue": "'tracing' is not defined",
		"searchLine": common_lib.build_search_line(["functions", fname], []),
	}
}
