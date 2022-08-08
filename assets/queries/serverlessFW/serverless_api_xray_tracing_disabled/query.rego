package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(document)
	provider := document.provider
	tracing := provider.tracing

	not common_lib.valid_key(tracing, "apiGateway")

	result := {
		"documentId": input.document[i].id,
		#"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider.tracing", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "tracing should have 'apiGateway' defined and set to true",
		"keyActualValue": "'apiGateway' is not defined within tracing",
		"searchLine": common_lib.build_search_line(["provider","tracing"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	sfw_lib.is_serverless_file(document)
	provider := document.provider
	tracing := provider.tracing

	tracing.apiGateway == false

	result := {
		"documentId": input.document[i].id,
		#"resourceType": resource.Type,
		"resourceName": document.service,
		"searchKey": sprintf("provider.tracing.apiGateway", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "tracing should have 'apiGateway' set to true",
		"keyActualValue": "'apiGateway' is set to false",
		"searchLine": common_lib.build_search_line(["provider","tracing","apiGateway"], []),
	}
}
