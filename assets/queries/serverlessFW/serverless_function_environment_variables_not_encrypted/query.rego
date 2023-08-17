package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	function := functions[fname]

	common_lib.valid_key(function, "environment")
	not common_lib.valid_key(function, "kmsKeyArn")


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

CxPolicy[result] {
	document := input.document[i]

	common_lib.valid_key(document.provider, "environment")
	not hasKMSarnAtProvider(document)
	

	result := {
		"documentId": input.document[i].id,
		"searchKey": "provider",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kmsKeyArn' should be defined inside the provider",
		"keyActualValue": "'kmsKeyArn' is not defined",
		"searchLine": common_lib.build_search_line(["provider"], []),
	}
}

hasKMSarnAtProvider(doc){
	common_lib.valid_key(doc.provider, "kmsKeyArn")
}
