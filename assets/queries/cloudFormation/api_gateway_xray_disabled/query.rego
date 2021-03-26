package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties
	isResFalse(properties.TracingEnabled)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.TracingEnabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TracingEnabled is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.TracingEnabled is false", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties
	object.get(properties, "TracingEnabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TracingEnabled is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.TracingEnabled is undefined", [name]),
	}
}

isResFalse(answer) {
	answer == "false"
} else {
	answer == false
}
