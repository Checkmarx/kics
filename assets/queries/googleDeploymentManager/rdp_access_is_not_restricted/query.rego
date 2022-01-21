package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.firewall"
	properties := resource.properties

	common_lib.is_ingress(properties)
	isRDPport(properties.allowed[_])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.allowed", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'allowed.ports' to not include RDP port 3389",
		"keyActualValue": "'allowed.ports' includes RDP port 3389", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "allowed"], []),
	}
}

isRDPport(allow) {
	isTCPorUDP(allow.IPProtocol)
	some j
	contains(allow.ports[j], "-")
	port_bounds := split(allow.ports[j], "-")
	low_bound := to_number(port_bounds[0])
	high_bound := to_number(port_bounds[1])
	isInBounds(low_bound, high_bound)
}

isRDPport(allow) {
	isTCPorUDP(allow.IPProtocol)
	some j
	contains(allow.ports[j], "-") == false
	to_number(allow.ports[j]) == 3389
}

isInBounds(low, high) {
	low <= 3389
	high >= 3389
}

isTCPorUDP(protocol) {
	lower(protocol) == "tcp"
}

isTCPorUDP(protocol) {
	lower(protocol) == "udp"
}
