package Cx

import data.generic.terraform as tf_lib
import data.generic.common as commonLib


CxPolicy[result] {
	#Case of aws_vpc_security_group_ingress_rule / aws_security_group_rule
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]

	is_security_group_ingress(types[i2],resource)
	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := tf_lib.getProtocolList(resource.ingress.protocol)[_]

	endswith(resource.ingress.cidr_blocks[_], "/0")
	tf_lib.containsPort(resource.ingress, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].ingress", [types[i2],name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

CxPolicy[result] {
	#Case of Single Ingress
	resource := input.document[i].resource.aws_security_group[name]

	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := tf_lib.getProtocolList(resource.ingress.protocol)[_]

	endswith(resource.ingress.cidr_blocks[_], "/0")
	tf_lib.containsPort(resource.ingress, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

CxPolicy[result] {
	#Case of Ingress Array
	resource := input.document[i].resource.aws_security_group[name]

	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
    ingress := resource.ingress[j]
	protocol := tf_lib.getProtocolList(ingress.protocol)[_]

	endswith(ingress.cidr_blocks[_], "/0")
	tf_lib.containsPort(ingress, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

isTCPorUDP("TCP") = true

isTCPorUDP("UDP") = true


is_security_group_ingress(type,resource) = false {
	type == "aws_security_group_rule"
	resource.type != "ingress"
} else = true 