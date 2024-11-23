package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	functions := document.functions
	is_object(functions)
	function := functions[fname]

	not common_lib.valid_key(function, "role")

	result := {
		"documentId": document.id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions.%s", [fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'role' should be defined inside the function",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions", fname], []),
	}
}

CxPolicy[result] {
	some document in input.document
	functions := document.functions
	is_array(functions)
	function := functions[k][fname]

	not common_lib.valid_key(function, "role")

	result := {
		"documentId": document.id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions[%s].%s", [k, fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'role' should be defined inside the function",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions", k, fname], []),
	}
}
