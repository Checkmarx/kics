package Cx

import data.generic.common as common_lib
import data.generic.terraform as terraform_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.cidr_ip == "0.0.0.0/0"
	isTCPorUDP(resource.ip_protocol)
	portContent := common_lib.tcpPortsMap[port]
	portNumber = port
	portName = portContent
	terraform_lib.containsPort(resource, portNumber)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_security_group_rule[%s].port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s:%d port should not be allowed", [resource.ip_protocol, portNumber]),
		"keyActualValue": sprintf("%s:%d port is allowed", [resource.ip_protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "port_range"], []),
	}
}

isTCPorUDP("tcp") = true

isTCPorUDP("udp") = true

isTCPorUDP("all") = true
