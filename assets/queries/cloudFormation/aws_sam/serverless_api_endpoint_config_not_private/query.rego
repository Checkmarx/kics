package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"

	not common_lib.valid_key(resource.Properties, "EndpointConfiguration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	endpointConfig := resource.Properties.EndpointConfiguration

	not common_lib.valid_key(endpointConfig, "Types")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EndpointConfiguration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "EndpointConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	endpointConfig := resource.Properties.EndpointConfiguration

	not contains_private(endpointConfig.Types)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EndpointConfiguration.Types", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' contains 'PRIVATE'", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' does not contain 'PRIVATE'", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "EndpointConfiguration", "Types"], []),
	}
}

contains_private(types) {
	types[_] == "PRIVATE"
}
