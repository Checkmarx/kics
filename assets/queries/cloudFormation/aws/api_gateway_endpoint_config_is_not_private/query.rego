package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"

	not common_lib.valid_key(resource.Properties, "EndpointConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration' is undefined", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	endpointConfig := resource.Properties.EndpointConfiguration

	not common_lib.valid_key(endpointConfig, "Types")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.EndpointConfiguration", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' is undefined", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	endpointConfig := resource.Properties.EndpointConfiguration

	not containsPrivate(endpointConfig.Types)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.EndpointConfiguration.Types", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' should contain 'PRIVATE'", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' does not contain 'PRIVATE'", [name]),
	}
}

containsPrivate(types) {
	types[_] == "PRIVATE"
}
