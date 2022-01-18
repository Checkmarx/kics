package Cx

import data.generic.common as common_lib

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
	properties.DestinationIpv6CidrBlock == "::/0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DestinationIpv6CidrBlock", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DestinationIpv6CidrBlock is different from the default value", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.DestinationIpv6CidrBlock is ::/0", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Route"

	properties := resource.Properties
	not common_lib.valid_key(properties, "NatGatewayId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NatGatewayId is defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.NatGatewayId is undefined", [key]),
	}
}
