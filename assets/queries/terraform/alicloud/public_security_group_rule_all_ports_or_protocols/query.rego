package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.cidr_ip == "0.0.0.0/0"
	isTCPorUDP(resource.ip_protocol)
	resource.port_range == "1/65535" 
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_security_group_rule[%s].port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0",
		"keyActualValue": sprintf("all ports are exposed for protocol %s",[resource.ip_protocol]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}

isTCPorUDP("tcp") = true

isTCPorUDP("udp") = true

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.cidr_ip == "0.0.0.0/0"
	isGREorICMPorALL(resource.ip_protocol)
	resource.port_range == "-1/-1" 
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_security_group_rule[%s].port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0'",
		"keyActualValue": "cidr_ip '0.0.0.0/0' exposes all ports for the specified protocol/protocols",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}

isGREorICMPorALL("icmp") = true

isGREorICMPorALL("gre") = true


CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.cidr_ip == "0.0.0.0/0"
	isALL(resource.ip_protocol)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_security_group_rule[%s].port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0' when protocol is equal to all",
		"keyActualValue": "All ports are exposed for all protocols",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}

isALL("all") = true
