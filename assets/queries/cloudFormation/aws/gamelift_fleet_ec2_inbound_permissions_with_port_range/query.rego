package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::GameLift::Fleet"

	properties := resource.Properties

	fromPort := to_number(properties.EC2InboundPermissions[index].FromPort)
	toPort := to_number(properties.EC2InboundPermissions[index].ToPort)
	fromPort != toPort

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.EC2InboundPermissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is not equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
	}
}
