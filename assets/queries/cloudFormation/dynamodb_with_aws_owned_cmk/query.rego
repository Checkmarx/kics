package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	properties.SSESpecification.SSEType == "KMS"
	properties.SSESpecification.SSEEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources[%s].properties.SSESpecification.SSEEnabled is true", [key]),
		"keyActualValue": sprintf("Resources[%s].properties.SSESpecification.SSEEnabled is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	object.get(properties, "SSESpecification", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.properties.SSESpecification is set", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.SSESpecification is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	object.get(properties.SSESpecification, "SSEType", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.properties.SSESpecification.SSEType is set", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.SSESpecification.SSEType is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties

	object.get(properties.SSESpecification, "SSEEnabled", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.properties.SSESpecification.SSEEnabled is set", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.SSESpecification.SSEEnabled is undefined", [key]),
	}
}
