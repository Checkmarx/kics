package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Method"
	properties := resource.Properties

	exists_api_key_kequired := object.get(properties, "ApiKeyRequired", "undefined") != "undefined"
	not exists_api_key_kequired

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ApiKeyRequired is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ApiKeyRequired is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Method"
	properties := resource.Properties
	properties.ApiKeyRequired == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ApiKeyRequired", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ApiKeyRequired is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ApiKeyRequired is false", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Method"
	properties := resource.Properties

	exists_http_method := object.get(properties, "HttpMethod", "undefined") != "undefined"
	exists_http_method

	not method_is_empty(properties.HttpMethod)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.HttpMethod", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.HttpMethod is empty", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.HttpMethod is not empty", [name]),
	}
}

method_is_empty(method) {
	method == ""
}

method_is_empty(method) {
	method == null
}
