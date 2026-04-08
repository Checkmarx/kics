package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

cidr_fields := ["CidrIp","CidrIpv6"]

CxPolicy[result] {
	cf_lib.getResourcesByType(input.document[i].Resources, "AWS::ECS::Service") != []
	cf_lib.getResourcesByType(input.document[i].Resources, "AWS::ECS::Cluster") != []

	types := ["AWS::EC2::SecurityGroup","AWS::EC2::SecurityGroupIngress"]

	resource := input.document[i].Resources[name]
	resource.Type == types[_]

	ingress_list := cf_lib.get_ingress_list(resource)
	results := exposed_inline_or_standalone_ingress(ingress_list[ing_index], ing_index, resource.Type, name)
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine" : results.searchLine,
	}
}

exposed_inline_or_standalone_ingress(resource, ing_index, type, resource_index) = results { # inline ingress
	type == "AWS::EC2::SecurityGroup"

	resource[cidr_fields[c]] == common_lib.unrestricted_ips[_]
	affects_all_ports(resource)

	results := {
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].%s", [resource_index, ing_index, cidr_fields[c]]),
		"keyExpectedValue": sprintf("Resource '%s' of type '%s' should not accept ingress connections from all addresses to all available ports", [resource_index, type]),
		"keyActualValue": sprintf("Resource '%s' of type '%s' is accepting ingress connections from all addresses to all available ports", [resource_index, type]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", "SecurityGroupIngress", ing_index, cidr_fields[c]],[])
	}
} else = results { # standalone ingress resource
	type == "AWS::EC2::SecurityGroupIngress"

	resource[cidr_fields[c]] == common_lib.unrestricted_ips[_]
	affects_all_ports(resource)

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s", [resource_index, cidr_fields[c]]),
		"keyExpectedValue": sprintf("Resource '%s' of type '%s' should not accept ingress connections from all addresses to all available ports", [resource_index, type]),
		"keyActualValue": sprintf("Resource '%s' of type '%s' is accepting ingress connections from all addresses to all available ports", [resource_index, type]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", cidr_fields[c]],[])
	}
} else = ""

affects_all_ports(resource) {
	resource.IpProtocol == "-1"
} else {
	resource.FromPort == 0
	resource.ToPort   == 65535
}
