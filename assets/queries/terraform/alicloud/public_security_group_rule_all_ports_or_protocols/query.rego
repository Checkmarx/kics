package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.type == "ingress"
	resource.cidr_ip == "0.0.0.0/0"
	isTCPorUDP(resource.ip_protocol)
	resource.port_range == "1/65535" 
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
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
	resource.type == "ingress"
	resource.cidr_ip == "0.0.0.0/0"
	isGREorICMP(resource.ip_protocol)
	resource.port_range == "-1/-1" 
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
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
	resource.type == "ingress"
	resource.cidr_ip == "0.0.0.0/0"
	resource.ip_protocol == "all"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_security_group_rule[%s].cidr_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cidr_ip should not be '0.0.0.0/0' when ip_protocol is equal to all",
		"keyActualValue": "cidr_ip is '0.0.0.0/0' when ip_protocol is equal to all",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "cidr_ip"], []),
	}
}
