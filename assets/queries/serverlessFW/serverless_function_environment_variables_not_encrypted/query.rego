package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	function := functions[fname]

	not common_lib.valid_key(function, "kmsKeyArn")
	not hasKMSarnAtProvider(document)

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions.%s", [fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kmsKeyArn' should be defined inside the function",
		"keyActualValue": "'kmsKeyArn' is not defined",
		"searchLine": common_lib.build_search_line(["functions", fname], []),
	}
}

hasKMSarnAtProvider(doc){
	common_lib.valid_key(doc.provider, "kmsKeyArn")
}
