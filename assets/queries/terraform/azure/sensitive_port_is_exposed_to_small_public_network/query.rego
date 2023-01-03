package Cx

import data.generic.terraform as tf_lib
import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_security_rule[name]

	portContent := commonLib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := tf_lib.getProtocolList(resource.protocol)[_]

	upper(resource.access) == "ALLOW"
	upper(resource.direction) == "INBOUND"
	
	isSmallPublicNetwork(resource)
	tf_lib.containsPort(resource, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_security_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_network_security_rule[%s].destination_port_range", [name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

isTCPorUDP("TCP") = true

isTCPorUDP("UDP") = true

isSmallPublicNetwork(resource) = private {
	endswith(resource.source_address_prefix, "/25")
	private = true
} else = private {
	endswith(resource.source_address_prefix, "/26")
	private = true
} else = private {
	endswith(resource.source_address_prefix, "/27")
	private = true
} else = private {
	endswith(resource.source_address_prefix, "/28")
	private = true
} else = private {
	endswith(resource.source_address_prefix, "/29")
	private = true
}
