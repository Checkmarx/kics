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
		"searchKey": sprintf("alicloud_security_group_rule[%s].cidr_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0' for the specified protocol",
		"keyActualValue": sprintf("cidr_ip '0.0.0.0/0' exposes all ports for the %s protocol", [resource.ip_protocol]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}

isTCPorUDP("tcp") = true

isTCPorUDP("udp") = true

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.cidr_ip == "0.0.0.0/0"
	isGREorICMP(resource.ip_protocol)
	resource.port_range == "-1/-1" 
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_security_group_rule[%s].cidr_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0' for the specified protocol",
		"keyActualValue": sprintf("cidr_ip '0.0.0.0/0' exposes all ports for the %s protocol", [resource.ip_protocol]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}

isGREorICMP("icmp") = true

isGREorICMP("gre") = true


CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.cidr_ip == "0.0.0.0/0"
	resource.ip_protocol == "all"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_security_group_rule[%s].cidr_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0' when protocol is equal to all",
		"keyActualValue": "cidr_ip '0.0.0.0/0' makes all ports exposed for all protocols",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}
