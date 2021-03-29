package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	portNumber := terraLib.portNumbers[j][0]
	portName := terraLib.portNumbers[j][1]
	protocol := terraLib.getProtocolList(resource.ingress.protocol)[_]

	isPrivateNetwork(resource)
	terraLib.containsPort(resource.ingress, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

isTCPorUDP("TCP") = true

isTCPorUDP("UDP") = true

isPrivateNetwork(resource) {
	some i
	commonLib.isPrivateIP(resource.ingress.cidr_blocks[i])
}
