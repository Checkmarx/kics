package Cx

import data.generic.common as commonLib

getFieldName(field) = name {
	upper(field) == "NETWORK PORTS SECURITY"
	name = "azurerm_network_security_rule"
}

getResource(document, field) = resource {
	resource := document.resource[field]
}

getProtocol(resource) = protocol {
	protocol = resource.protocol
}

getProtocolList(protocol) = list {
	protocol == "*"
	list = ["TCP", "UDP", "Icmp"]
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
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), resource.destination_port_range)
	containing = true
}

else = containing {
	ports = split(resource.destination_port_range, ",")
	sublist = split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= port
	to_number(trim(sublist[1], " ")) >= port
	containing = true
}

isAccessibleFromEntireNetwork(resource) = accessible {
	endswith(resource.source_address_prefix, "/0")
	accessible = true
}

isAllowed(resource) = allowed {
	upper(resource.access) == "ALLOW"
	allowed = true
}

isTCPorUDP(protocol) = is {
	is = upper(protocol) != "ICMP"
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
	isAllowed(resource)
	isAccessibleFromEntireNetwork(resource)
	containsDestinationPort(portNumber, resource)
	isTCPorUDP(protocol)

	#############	Result
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].destination_port_range", [field, var0]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s[%s]", [portName, protocol, portNumber, field, var0]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in %s[%s]", [portName, protocol, portNumber, field, var0]),
	}
}
