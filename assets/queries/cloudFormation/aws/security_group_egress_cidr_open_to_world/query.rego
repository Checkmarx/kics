package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	resource := docs.Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupEgress"

	properties := resource.Properties

	properties.CidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrIp", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CidrIp should not be open to the world", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CidrIp is open to the world", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["CidrIp"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	resource := docs.Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupEgress"

	properties := resource.Properties

	properties.CidrIpv6 == "::/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrIpv6", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CidrIpv6 should not be open to the world", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CidrIpv6 is open to the world", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["CidrIpv6"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	resource := docs.Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupEgress[index].CidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIp", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIp should not be open to the world", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIp is open to the world", [name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupEgress", index], ["CidrIp"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	resource := docs.Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupEgress[index].CidrIpv6 == "::/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIpv6", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIpv6 should not be open to the world", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIpv6 is open to the world", [name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupEgress", index], ["CidrIpv6"]),
	}
}
