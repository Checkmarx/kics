package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(document)
	functions := document.functions
	function := functions[fname]

	not common_lib.valid_key(function, "kmsKeyArn")

	result := {
		"documentId": input.document[i].id,
		#"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("functions.%s", [fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kmsKeyArn' should be defined inside the function",
		"keyActualValue": "'kmsKeyArn' is not defined",
		"searchLine": common_lib.build_search_line(["functions",fname], []),
	}
}
