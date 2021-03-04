package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	object.get(resource.Properties, "AccessLogSettings", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings is not defined", [name]),
	}
}
