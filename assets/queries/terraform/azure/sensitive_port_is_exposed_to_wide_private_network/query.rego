package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_network_security_rule[name]

	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	some protocol in tf_lib.getProtocolList(resource.protocol)

	upper(resource.access) == "ALLOW"
	upper(resource.direction) == "INBOUND"

	commonLib.isPrivateIP(resource.source_address_prefix)
	tf_lib.containsPort(resource, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_network_security_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_network_security_rule[%s].destination_port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

isTCPorUDP("TCP") = true

isTCPorUDP("UDP") = true
