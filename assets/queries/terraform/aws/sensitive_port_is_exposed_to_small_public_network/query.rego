package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	#Case of aws_vpc_security_group_ingress_rule / aws_security_group_rule
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	protocol_field_name := ["ip_protocol","protocol"]
	resource := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],resource)
	portContent := common_lib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := tf_lib.getProtocolList(resource[protocol_field_name[i2]])[_]

	isSmallPublicNetwork(resource)
	tf_lib.containsPort(resource, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [types[i2],name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["resource", types[i2], name], []),
	}
}

CxPolicy[result] {
	#Case of Single Ingress or Ingress Array
	resource := input.document[i].resource.aws_security_group[name]

	portContent := common_lib.tcpPortsMap[port]

	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	ingress := ingress_list.value[i2]
	results := is_exposed_to_small_public_network(ingress,ingress_list.is_unique_element,name,i2,port,portContent,tf_lib.getProtocolList(ingress.protocol)[_])
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"searchValue": results.searchValue,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

is_exposed_to_small_public_network(ingress,is_unique_element,name,i2,portNumber,portName,protocol) = results {
	is_unique_element

	isSmallPublicNetwork(ingress)
	tf_lib.containsPort(ingress, portNumber)
	isTCPorUDP(protocol)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
} else = results {
	not is_unique_element

	isSmallPublicNetwork(ingress)
	tf_lib.containsPort(ingress, portNumber)
	isTCPorUDP(protocol)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),
	}
} else = ""

isTCPorUDP("TCP") = true

isTCPorUDP("UDP") = true


small_network_affix := ["/25","/26","/27","/28","/29"]

isSmallPublicNetwork(resource) {
	endswith(resource.cidr_blocks[_], small_network_affix[_])
} else {
	endswith(resource.ipv6_cidr_blocks[_], small_network_affix[_])
} else {
	endswith(resource.cidr_ipv4, small_network_affix[_])
} else {
	endswith(resource.cidr_ipv6, small_network_affix[_])
}
