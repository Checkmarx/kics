package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	[path, Resources] := walk(docs)
	some key in Resources

	resource := Resources[key]
	resource.Type == "AWS::EC2::Route"

	properties := resource.Properties
	properties.DestinationCidrBlock == "0.0.0.0/0"

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("%s%s.Properties.DestinationCidrBlock", [cf_lib.getPath(path), key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DestinationCidrBlock should be different from the default value", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.DestinationCidrBlock is 0.0.0.0/0", [key]),
	}
}

CxPolicy[result] {
	some doc in input.document
	[path, Resources] := walk(docs)
	some key in Resources

	resource := Resources[key]
	resource.Type == "AWS::EC2::Route"

	properties := resource.Properties
	properties.DestinationIpv6CidrBlock == "::/0"

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("%s%s.Properties.DestinationIpv6CidrBlock", [cf_lib.getPath(path), key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DestinationIpv6CidrBlock should be different from the default value", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.DestinationIpv6CidrBlock is ::/0", [key]),
	}
}

CxPolicy[result] {
	some doc in input.document
	[path, Resources] := walk(docs)
	some key in Resources

	resource := Resources[key]
	resource.Type == "AWS::EC2::Route"

	properties := resource.Properties
	not common_lib.valid_key(properties, "NatGatewayId")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NatGatewayId should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.NatGatewayId is undefined", [key]),
	}
}
