package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	types := {"AWS::EC2::SecurityGroupIngress","AWS::EC2::SecurityGroup"}
	resources := input.document[i].Resources
	resource := resources[resource_name]
	resource.Type == types[t]

	ingress_list := cf_lib.get_ingress_list(resource)
	ingress := ingress_list[ing_index]

	# check that it is exposed
	cidr_fields := {"CidrIp", "CidrIpv6"}
	endswith(ingress[cidr_fields[c]], "/0")

	# get relevant ports for protocol(s)
	protocols := getProtocolList(ingress.IpProtocol)
	protocol := protocols[m]
	portsMap := common_lib.tcpPortsMap

	#check that relevant port numbers are included
	portRange := numbers.range(ingress.FromPort, ingress.ToPort)
	portNumber := portRange[idx]
	portName := portsMap[portNumber]

	results := get_search_values(ing_index, resource.Type, resource_name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, resource_name),
		"searchKey": results.searchKey,
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": results.searchLine,
	}
}

get_search_values(ing_index, type, resource_name) = results {
	type == "AWS::EC2::SecurityGroup"

	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupIngress[%d]", [resource_name, ing_index]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_name, "Properties", "SecurityGroupIngress", ing_index], []),
	}

} else = results {
	type == "AWS::EC2::SecurityGroupIngress"

	results := {
		"searchKey" : sprintf("Resources.%s.Properties", [resource_name]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_name, "Properties"], []),
	}
}

getProtocolList(protocol) = list {
	protocol == "-1"
	list = ["TCP", "UDP"]
} else = list {
	upper(protocol) == "TCP"
	list = ["TCP"]
} else = list {
	upper(protocol) == "UDP"
	list = ["UDP"]
}