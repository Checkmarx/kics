package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupIngress"

	properties := resource.Properties

	properties.IpProtocol == -1

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IpProtocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IpProtocol is not set to -1", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IpProtocol is set to -1", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupIngress[index].IpProtocol == -1

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress.IpProtocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].IpProtocol is not set to -1", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].IpProtocol is set to -1", [name, index]),
	}
}
