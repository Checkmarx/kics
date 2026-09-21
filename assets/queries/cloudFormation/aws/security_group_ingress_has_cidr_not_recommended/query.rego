package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupIngress"

	properties := resource.Properties

	contains(properties.CidrIp, "/32")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrIp", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CidrIp should not be /32", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CidrIp is /32", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["CidrIp"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupIngress"

	properties := resource.Properties

	contains(properties.CidrIpv6, "/128")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrIpv6", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CidrIpv6 should not be /128", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CidrIpv6 is /128", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["CidrIpv6"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	contains(properties.SecurityGroupIngress[index].CidrIp, "/32")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress.CidrIp", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp should not be /32", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp is /32", [name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index], ["CidrIp"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	contains(properties.SecurityGroupIngress[index].CidrIpv6, "/128")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress.CidrIpv6", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6 should not be /128", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6 is /128", [name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index], ["CidrIpv6"]),
	}
}
