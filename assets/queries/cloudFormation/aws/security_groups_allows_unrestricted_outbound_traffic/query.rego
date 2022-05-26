package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resources := document[i].Resources[name]

	resources.Type == "AWS::EC2::SecurityGroup"

	properties := resources.Properties
	properties.SecurityGroupEgress[j].IpProtocol == "ALL"
	properties.SecurityGroupEgress[j].CidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d]", [name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d] must have different IpProtocol from 'ALL' and CidrIp from '0.0.0.0/0'.", [name, j]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d] must not have IpProtocol as 'ALL' and CidrIp as '0.0.0.0/0'.", [name, j]),
	}
}
