package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"

	object.get(resource.Properties, "EndpointConfiguration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
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

	object.get(endpointConfig, "Types", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
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
		"searchKey": sprintf("Resources.%s.Properties.EndpointConfiguration.Types", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.EndpointConfiguration.Types' contains 'PRIVATE'", [name]),
		"keyActualValue": sprintf("'Resources.%s.EndpointConfiguration.Types' does not contain 'PRIVATE'", [name]),
	}
}

containsPrivate(types) {
	types[_] == "PRIVATE"
}
