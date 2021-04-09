package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	not check_resources_type("AWS::ApiGateway::Stage")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s has Stage defined", [name]),
		"keyActualValue": sprintf("Resources.%s doesn't have Stage defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	check_resources_type("AWS::ApiGateway::Stage")
	not settings_are_equal(document[i].Resources, name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s has AWS::ApiGateway::Stage associated, DeploymentId.Ref is the same as the ApiGateway::Stage resource", [name]),
		"keyActualValue": sprintf("Resources.%s should have AWS::ApiGateway::Stage associated, DeploymentId.Ref should be the same in the ApiGateway::Stage resource", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	check_resources_type("AWS::ApiGateway::Stage")
	settings_are_equal(document[i].Resources, name)

	object.get(resource.Properties, "StageDescription", "undefined") = "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StageDescription", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StageDescription is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StageDescription is not defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	check_resources_type("AWS::ApiGateway::Stage")
	settings_are_equal(document[i].Resources, name)

	object.get(resource.Properties.StageDescription, "AccessLogSetting", "undefined") = "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StageDescription.AccessLogSetting", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StageDescriptionAccessLogSetting is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StageDescription.AccessLogSetting is not defined", [name]),
	}
}

check_resources_type(resourceType) {
	resource := input.document[_].Resources
	resource[_].Type == resourceType
}

settings_are_equal(resource, deploymentName) {
	resource[_].Type == "AWS::ApiGateway::Stage"
	resource[_].Properties.DeploymentId.Ref == deploymentName
}
