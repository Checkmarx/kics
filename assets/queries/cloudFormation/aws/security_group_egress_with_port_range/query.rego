package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	resource := docs.Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupEgress"

	properties := resource.Properties

	properties.FromPort != properties.ToPort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.FromPort should equal to Resources.%s.Properties.ToPort", [name, name]),
		"keyActualValue": sprintf("Resources.%s.Properties.FromPort is not equal to Resources.%s.Properties.ToPort", [name, name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	resource := docs.Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupEgress[index].FromPort != properties.SecurityGroupEgress[index].ToPort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d]", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].FromPort should equal to Resources.%s.Properties.SecurityGroupEgress[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].FromPort is not equal to Resources.%s.Properties.SecurityGroupEgress[%d].ToPort", [name, index, name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupEgress", index], []),
	}
}
