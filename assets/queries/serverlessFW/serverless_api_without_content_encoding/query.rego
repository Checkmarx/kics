package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	provider := document.provider
	apiGateway := provider.apiGateway

	not common_lib.valid_key(apiGateway, "minimumCompressionSize")

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("api", document.provider.name),
		"resourceName": sfw_lib.get_service_name(document),
		"searchKey": sprintf("provider.apiGateway", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "apiGateway should have 'minimumCompressionSize' defined and set to a recommended value",
		"keyActualValue": "apiGateway does not have 'minimumCompressionSize' defined",
		"searchLine": common_lib.build_search_line(["provider", "apiGateway"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	provider := document.provider
	apiGateway := provider.apiGateway

	unrecommended_minimum_compression_size(apiGateway.minimumCompressionSize)

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("api", document.provider.name),
		"resourceName": sfw_lib.get_service_name(document),
		"searchKey": sprintf("provider.apiGateway.minimumCompressionSize", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimumCompressionSize' should be set to a recommended value",
		"keyActualValue": "'minimumCompressionSize' is set a unrecommended value",
		"searchLine": common_lib.build_search_line(["provider", "apiGateway", "minimumCompressionSize"], []),
	}
}

unrecommended_minimum_compression_size(value) {
	value < 0
} else {
	value > 10485759
}
