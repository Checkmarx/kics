package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	firewall := input.document[i].resource.google_compute_firewall[name]

	common_lib.is_ingress(firewall)
	common_lib.is_unrestricted(firewall.source_ranges[_])
	allowed := getAllowed(firewall)
	isRDPport(allowed[a])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_firewall",
		"resourceName": tf_lib.get_resource_name(firewall, name),
		"searchKey": sprintf("google_compute_firewall[%s].allow.ports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_firewall[%s].allow.ports' should not include RDP port 3389", [name]),
		"keyActualValue": sprintf("'google_compute_firewall[%s].allow.ports' includes RDP port 3389", [name]),
		"searchLine": common_lib.build_search_line(["google_compute_firewall", name, "allow", a], []),
	}
}

getAllowed(firewall) = allowed {
	is_array(firewall.allow)
	allowed := firewall.allow
}

getAllowed(firewall) = allowed {
	is_object(firewall.allow)
	allowed := [firewall.allow]
}

isRDPport(allow) {
	isTCPorUDP(allow.protocol)
	contains(allow.ports[j], "-")
	port_bounds := split(allow.ports[j], "-")
	low_bound := to_number(port_bounds[0])
	high_bound := to_number(port_bounds[1])
	isInBounds(low_bound, high_bound)
} else {
	isTCPorUDP(allow.protocol)
	contains(allow.ports[j], "-") == false
	to_number(allow.ports[j]) == 3389
} else {
    not allow.ports
    isTCPorUDP(allow.protocol)
}

isInBounds(low, high) {
	low <= 3389
	high >= 3389
}

isTCPorUDP(protocol) {
	protocols := {"tcp", "udp", "all"}
	lower(protocol) == protocols[_]
}
