package Cx

import data.generic.common as common_lib
import data.generic.severlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(resource)
	logs := document.provider.logs
	restAPI := logs.restApi
	
	not common_lib.valid_key(restAPI, "accessLogging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider.logs.restApi", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "provider.logs.restApi should have 'accessLogging' is defined and set to true",
		"keyActualValue": "provider.logs.restApi does not have 'accessLogging' defined",
		"searchLine": common_lib.build_search_line(["provider","logs", "restApi"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(resource)
	logs := document.provider.logs
	restAPI := logs.restApi

	restAPI.accessLogging == false	

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider.logs.restApi.accessLogging", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "provider.logs.restApi should have 'accessLogging' set to true",
		"keyActualValue": "provider.logs.restApi has 'accessLogging' set to false",
		"searchLine": common_lib.build_search_line(["provider","logs", "restApi", "accessLogging"], []),
	}
}
