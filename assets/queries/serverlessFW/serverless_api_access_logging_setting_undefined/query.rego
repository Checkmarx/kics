package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(document)
	logs := document.provider.logs
	restAPI := logs.restApi

	restAPI.accessLogging == false	

	result := {
		"documentId": input.document[i].id,
		#"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider.logs.restApi.accessLogging", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "provider.logs.restApi should have 'accessLogging' set to true",
		"keyActualValue": "provider.logs.restApi has 'accessLogging' set to false",
		"searchLine": common_lib.build_search_line(["provider","logs", "restApi", "accessLogging"], []),
	}
}
