package Cx

CxPolicy[result] {
	firewall := input.document[i].resource.google_compute_firewall[name]
	isDirIngress(firewall)
	firewall.source_ranges[_] == "0.0.0.0/0" # Allow traffic from anywhere
	allowed := getAllowed(firewall)

	isSSHport(allowed[_])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_firewall[%s].allow.ports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_firewall[%s].allow.ports' does not include SSH port 22", [name]),
		"keyActualValue": sprintf("'google_compute_firewall[%s].allow.ports' includes SSH port 22", [name]),
	}
}

isDirIngress(firewall) {
	firewall.direction == "INGRESS"
}

isDirIngress(firewall) {
	not firewall.direction
}

getAllowed(firewall) = allowed {
	is_array(firewall.allow)
	allowed := firewall.allow
}

getAllowed(firewall) = allowed {
	is_object(firewall.allow)
	allowed := [firewall.allow]
}

isSSHport(allow) {
	some j
	contains(allow.ports[j], "-")
	port_bounds := split(allow.ports[j], "-")
	low_bound := to_number(port_bounds[0])
	high_bound := to_number(port_bounds[1])
	isInBounds(low_bound, high_bound)
}

isSSHport(allow) {
	some j
	contains(allow.ports[j], "-") == false
	to_number(allow.ports[j]) == 22
}

isInBounds(low, high) {
	low <= 22
	high >= 22
}
