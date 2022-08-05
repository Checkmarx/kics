package Cx

import data.generic.common as common_lib
import data.generic.severlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(resource)
	functions := document.functions
	function := functions[fname]

	not common_lib.valid_key(function, "tags")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("functions.%s", [fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'tags' should be defined inside the function",
		"keyActualValue": "'tags' is not defined",
		"searchLine": common_lib.build_search_line(["functions",fname], []),
	}
}
