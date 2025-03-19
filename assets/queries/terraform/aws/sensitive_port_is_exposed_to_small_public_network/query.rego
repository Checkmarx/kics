package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := tf_lib.getProtocolList(resource.ingress.protocol)[_]

	is_small_net := isSmallPublicNetwork(resource)
	port_contains := tf_lib.containsPort(resource.ingress, portNumber)

	is_small_net
	port_contains
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

isSmallPublicNetwork(resource) {
	endswith(resource.ingress.cidr_blocks[_], "/25")
} else {
	endswith(resource.ingress.cidr_blocks[_], "/26")
} else {
	endswith(resource.ingress.cidr_blocks[_], "/27")
} else {
	endswith(resource.ingress.cidr_blocks[_], "/28")
} else {
	endswith(resource.ingress.cidr_blocks[_], "/29")
}
