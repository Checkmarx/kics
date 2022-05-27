package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	portContent := common_lib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := tf_lib.getProtocolList(resource.ingress.protocol)[_]

	isPrivateNetwork(resource)
	tf_lib.containsPort(resource.ingress, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	ingressKey := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_with_cidr_blocks")
	common_lib.valid_key(module, ingressKey)

	portContent := common_lib.tcpPortsMap[port]
	portNumber = port
	portName = portContent

	ingress := module[ingressKey][idx]
	protocol := tf_lib.getProtocolList(ingress.protocol)[_]

	common_lib.isPrivateIP(ingress.cidr_blocks[_])
	tf_lib.containsPort(ingress, portNumber)
	isTCPorUDP(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, ingressKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["module", name, ingressKey], []),
	}
}

isTCPorUDP("TCP") = true

isTCPorUDP("UDP") = true

isPrivateNetwork(resource) {
	some i
	common_lib.isPrivateIP(resource.ingress.cidr_blocks[i])
}
