package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupEgress"

	properties := resource.Properties

	properties.FromPort != properties.ToPort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.FromPort should equal to Resources.%s.Properties.ToPort", [name, name]),
		"keyActualValue": sprintf("Resources.%s.Properties.FromPort is not equal to Resources.%s.Properties.ToPort", [name, name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupEgress[index].FromPort != properties.SecurityGroupEgress[index].ToPort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupEgress[%d]", [cf_lib.getPath(path), name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].FromPort should equal to Resources.%s.Properties.SecurityGroupEgress[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].FromPort is not equal to Resources.%s.Properties.SecurityGroupEgress[%d].ToPort", [name, index, name, index]),
	}
}
