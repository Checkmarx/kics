package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"

	not common_lib.valid_key(resource.Properties, "EndpointConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	endpointConfig := resource.Properties.EndpointConfiguration

	not common_lib.valid_key(endpointConfig, "Types")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.EndpointConfiguration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	endpointConfig := resource.Properties.EndpointConfiguration

	not containsPrivate(endpointConfig.Types)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.EndpointConfiguration.Types", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' contains 'PRIVATE'", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' does not contain 'PRIVATE'", [name]),
	}
}

containsPrivate(types) {
	types[_] == "PRIVATE"
}
