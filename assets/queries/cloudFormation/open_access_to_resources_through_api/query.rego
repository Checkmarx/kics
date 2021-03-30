package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Method"
	properties := resource.Properties

	properties.AuthorizationType = "NONE"
	properties.HttpMethod != "OPTIONS"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AuthorizationType", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AuthorizationType is not equal 'NONE'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AuthorizationType is equal 'NONE'", [name]),
	}
}
