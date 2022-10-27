package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.type == "ingress"
	resource.cidr_ip == "0.0.0.0/0"
	isTCPorUDP(resource.ip_protocol)
    containsUnknownPort(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_security_group_rule[%s].port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "port_range should not contain unknown ports and should not be exposed to the entire Internet",
		"keyActualValue": "port_range contains unknown ports and are exposed to the entire Internet",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "port_range"], []),
	}
}

isTCPorUDP("tcp") = true

isTCPorUDP("udp") = true


CxPolicy[result] {
	resource := input.document[i].resource.alicloud_security_group_rule[name]
	resource.type == "ingress"
	resource.cidr_ip == "0.0.0.0/0"
	resource.ip_protocol == "all"
	resource.port_range == "-1/-1"
    containsUnknownPortForAll(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_security_group_rule[%s].port_range", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "port_range should not contain ports unknown and should not be exposed to the entire Internet",
		"keyActualValue": "port_range contains ports unknown and are exposed to the entire Internet",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_security_group_rule", name, "port_range"], []),
	}
}


containsUnknownPort(rule){
    sublist := split(rule.port_range, "/")
    from_port :=  to_number(sublist[0])
    to_port := to_number(sublist[1])
    port := numbers.range(from_port, to_port)[i]
    not common_lib.valid_key(common_lib.tcpPortsMap,port)
}

containsUnknownPortForAll(rule){
    rule.port_range == "-1/-1"
    from_port :=  1
    to_port := 65535
    port := numbers.range(from_port, to_port)[i]
    not common_lib.valid_key(common_lib.tcpPortsMap,port)
}
