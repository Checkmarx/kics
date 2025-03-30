package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	portNumber = port
	portContent := commonLib.tcpPortsMap[port]
	portName = portContent

	protocol := tf_lib.getProtocolList(resource.ingress.protocol)[_]
	isTCPorUDP(protocol)

	cidr_blocks := endswith(resource.ingress.cidr_blocks[_], "/0")
	cidr_blocks

	port_number := tf_lib.containsPort(resource.ingress, portNumber)
	port_number

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
	resource := input.document[i].resource.aws_security_group[name]

	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	ingress := resource.ingress[j]

	protocol := tf_lib.getProtocolList(ingress.protocol)[_]
	isTCPorUDP(protocol)

	ends_with := endswith(ingress.cidr_blocks[_], "/0")
	ends_with

	port_contains := tf_lib.containsPort(ingress, portNumber)
	port_contains

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
