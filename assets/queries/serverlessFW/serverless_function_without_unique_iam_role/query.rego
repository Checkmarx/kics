package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	is_object(functions)
	function := functions[fname]

	not common_lib.valid_key(function, "role")

	result := {
		"documentId": input.document[i].id,
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
	document := input.document[i]
	functions := document.functions
	is_array(functions)
	function := functions[k][fname]

	not common_lib.valid_key(function, "role")

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions[%s].%s", [k,fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'role' should be defined inside the function",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions",k ,fname], []),
	}
}
