package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(document)
	provider := document.provider

	endpointType := provider.endpointType
	endpointType != "PRIVATE"


	result := {
		"documentId": input.document[i].id,
		#"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider.endpointType", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "endpointType should be set to PRIVATE",
		"keyActualValue": "endpointType is not set to PRIVATE",
		"searchLine": common_lib.build_search_line(["provider","endpointType"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(document)
	provider := document.provider

	not common_lib.valid_key(provider, "endpointType")

	result := {
		"documentId": input.document[i].id,
		#"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "endpointType should be defined and set to PRIVATE",
		"keyActualValue": "endpointType is not defined",
		"searchLine": common_lib.build_search_line(["provider",], []),
	}
}
