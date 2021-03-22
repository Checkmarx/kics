package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	properties.MinimumCompressionSize < 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MinimumCompressionSize", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Resources.%s.Properties.MinimumCompressionSize, is greater than -1 and smaller than 10485760",
		"keyActualValue": "Resources.%s.Properties.MinimumCompressionSize, is set but smaller than 0",
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	properties.MinimumCompressionSize > 10485759

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MinimumCompressionSize", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Resources.%s.Properties.MinimumCompressionSize, is greater than -1 and smaller than 10485760",
		"keyActualValue": "Resources.%s.Properties.MinimumCompressionSize, is set but greater than 10485759",
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	object.get(properties, "MinimumCompressionSize", "undefined") = "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MinimumCompressionSize is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MinimumCompressionSize is not defined", [name]),
	}
}
