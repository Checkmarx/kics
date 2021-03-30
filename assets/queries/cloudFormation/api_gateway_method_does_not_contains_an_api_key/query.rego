package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::ApiGateway::Method"

	object.get(resource.Properties, "ApiKeyRequired", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ApiKeyRequired is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ApiKeyRequired is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::ApiGateway::Method"

	resource.Properties.ApiKeyRequired == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.ApiKeyRequired", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ApiKeyRequired is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ApiKeyRequired is false", [name]),
	}
}
