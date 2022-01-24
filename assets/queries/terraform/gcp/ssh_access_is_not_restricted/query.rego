package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	firewall := input.document[i].resource.google_compute_firewall[name]
	common_lib.is_ingress(firewall)
	common_lib.is_unrestricted(firewall.source_ranges[_]) # Allow traffic from anywhere
	allowed := getAllowed(firewall)

	ports := isSSHport(allowed[a])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_firewall[%s].allow.ports=%s", [name, ports]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_firewall[%s].allow.ports' does not include SSH port 22", [name]),
		"keyActualValue": sprintf("'google_compute_firewall[%s].allow.ports' includes SSH port 22", [name]),
		"searchLine": common_lib.build_search_line(["google_compute_firewall", name, "allowed", a, "ports"], []),
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

isSSHport(allow) = ports {
	contains(allow.ports[j], "-")
	port_bounds := split(allow.ports[j], "-")
	low_bound := to_number(port_bounds[0])
	high_bound := to_number(port_bounds[1])
	isInBounds(low_bound, high_bound)
    ports := allow.ports[j]
}

isSSHport(allow) = ports {
	contains(allow.ports[j], "-") == false
	to_number(allow.ports[j]) == 22
    ports := allow.ports[j]
}

isInBounds(low, high) {
	low <= 22
	high >= 22
}
