package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Route"

	properties := resource.Properties
	properties.DestinationCidrBlock == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DestinationCidrBlock", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DestinationCidrBlock is different from the default value", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.DestinationCidrBlock is 0.0.0.0/0", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Route"

	properties := resource.Properties
	object.get(properties, "GatewayId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.GatewayId is defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.GatewayId is undefined", [key]),
	}
}
