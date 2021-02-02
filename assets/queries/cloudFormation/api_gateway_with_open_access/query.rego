package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Method"

	none := "NONE"
	resource.Properties.AuthorizationType == none

	options := "OPTIONS"
	resource.Properties.HttpMethod != options

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AuthorizationType", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AuthorizationType is %s and Resources.%s.Properties.HttpMethod is %s", [name, none, name, options]),
		"keyActualValue": sprintf("Resources.%s.Properties.AuthorizationType is %s and Resources.%s.Properties.HttpMethod is not %s", [name, none, name, options]),
	}
}
