package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupIngress"

	properties := resource.Properties

	properties.CidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrIp", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CidrIp should not be open to the world (0.0.0.0/0)", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CidrIp is open to the world (0.0.0.0/0)", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["CidrIp"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupIngress"

	properties := resource.Properties

	properties.CidrIpv6 == "::/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrIpv6", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CidrIpv6 should not be open to the world (::/0)", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CidrIpv6 is open to the world (::/0)", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["CidrIpv6"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupIngress[index].CidrIp == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index, "CidrIp"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp should not be open to the world (0.0.0.0/0)", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp is open to the world (0.0.0.0/0)", [name, index]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupIngress[index].CidrIpv6 == "::/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6", [name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index, "CidrIpv6"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6 should not be open to the world (::/0)", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6 is open to the world (::/0)", [name, index]),
	}
}
