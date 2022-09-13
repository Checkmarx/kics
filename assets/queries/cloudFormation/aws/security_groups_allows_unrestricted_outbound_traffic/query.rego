package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]

	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties
	properties.SecurityGroupEgress[j].IpProtocol == "ALL"
	properties.SecurityGroupEgress[j].CidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupEgress[%d]", [cf_lib.getPath(path), name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d] should have different IpProtocol from 'ALL' and CidrIp from '0.0.0.0/0'.", [name, j]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d] must not have IpProtocol as 'ALL' and CidrIp as '0.0.0.0/0'.", [name, j]),
	}
}
