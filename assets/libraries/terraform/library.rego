package generic.terraform

# Checks if a TCP port is open in a rule
openPort(rule, port) {
	rule.cidr_blocks[_] == "0.0.0.0/0"
	rule.protocol == "tcp"
	containsPort(rule, port)
}

openPort(rules, port) {
	rule := rules[_]
	rule.cidr_blocks[_] == "0.0.0.0/0"
	rule.protocol == "tcp"
	containsPort(rule, port)
}

# Checks if a port is included in a rule
containsPort(rule, port) {
	rule.from_port <= port
	rule.to_port >= port
}

else {
	rule.from_port == 0
	rule.to_port == 0
}

else {
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), rule.destination_port_range)
}

else {
	ports := split(rule.destination_port_range, ",")
	sublist := split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= port
	to_number(trim(sublist[1], " ")) >= port
}

# Gets the list of protocols
getProtocolList("-1") = protocols {
	protocols := ["TCP", "UDP", "ICMP"]
}

getProtocolList("*") = protocols {
	protocols := ["TCP", "UDP", "ICMP"]
}

getProtocolList(protocol) = protocols {
	upper(protocol) == "TCP"
	protocols := ["TCP"]
}

getProtocolList(protocol) = protocols {
	upper(protocol) == "UDP"
	protocols := ["UDP"]
}

# Checks if any principal are allowed ina policy
anyPrincipal(statement) {
	contains(statement.Principal, "*")
}

anyPrincipal(statement) {
	is_string(statement.Principal.AWS)
	contains(statement.Principal.AWS, "*")
}

anyPrincipal(statement) {
	is_array(statement.Principal.AWS)
	some i
	contains(statement.Principal.AWS[i], "*")
}

getSpecInfo(resource) = specInfo { # this one can be also used for the result
	spec := resource.spec.job_template.spec.template.spec
	specInfo := {"spec": spec, "path": "spec.job_template.spec.template.spec"}
} else = specInfo {
	spec := resource.spec.template.spec
	specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
	spec := resource.spec
	specInfo := {"spec": spec, "path": "spec"}
}
