package Cx

import data.generic.common as commonLib

getFieldName(field) = name {
	upper(field) == "NETWORK PORTS SECURITY"
	name = "aws_security_group"
}

getResource(document, field) = resource {
	resource := document.resource[field]
}

getProtocol(resource) = protocol {
	protocol = resource.ingress.protocol
}

getProtocolList(protocol) = list {
	protocol == "-1"
	list = ["TCP", "UDP", "Icmp", "icmpv6"]
}

else = list {
	upper(protocol) == "TCP"
	list = ["TCP"]
}

else = list {
	upper(protocol) == "UDP"
	list = ["UDP"]
}

else = list {
	upper(protocol) == "ICMP"
	list = ["Icmp"]
}

containsDestinationPort(port, resource) = containing {
	portStart = resource.ingress.from_port
	portEnd = resource.ingress.to_port
	portStart <= port
	portEnd >= port
	containing = true
}

else = containing {
	resource.ingress.from_port == 0
	resource.ingress.to_port == 0
	containing = true
}

isAccessibleFromEntireNetwork(resource) = accessible {
	endswith(resource.ingress.cidr_blocks[_], "/0")
	accessible = true
}

isTCPorUDP(protocol) = is {
	tcpUdp = ["TCP", "UDP"]
	is = upper(protocol) == tcpUdp[_]
}

CxPolicy[result] {
	#############	inputs
    tcpPortsMap := commonLib.tcpPortsMap

	field = getFieldName("Network Ports Security") # Category/service used

	#############	document and resource
	document := commonLib.getDocument([])[i]
	resource := getResource(document, field)[var0]

	#############	get relevant fields
	portContent := tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocolList = getProtocolList(getProtocol(resource))
	protocol = protocolList[k]

	#############	Checks
	isAccessibleFromEntireNetwork(resource)
	containsDestinationPort(portNumber, resource)
	isTCPorUDP(protocol)

	#############	Result
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].ingress", [field, var0]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s[%s]", [portName, protocol, portNumber, field, var0]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in %s[%s]", [portName, protocol, portNumber, field, var0]),
	}
}
