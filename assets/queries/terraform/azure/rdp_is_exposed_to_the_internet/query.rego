package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_security_rule[var0]
	upper(resource.access) == "ALLOW"

	isRelevantProtocol(resource.protocol)
	isRelevantPort(resource.destination_port_range)
	isRelevantAddressPrefix(resource.source_address_prefix)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_security_rule[%s].destination_port_range", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_security_rule.%s.destination_port_range' cannot be 3389", [var0]),
		"keyActualValue": sprintf("'azurerm_network_security_rule.%s.destination_port_range' might be 3389", [var0]),
	}
}

isRelevantProtocol(protocol) = allow {
	upper(protocol) != "UDP"
	upper(protocol) != "ICMP"
	allow = true
}

isRelevantPort(port) = allow {
	regex.match("(^|\\s|,)3389(-|,|$|\\s)", port)
	allow = true
}

else = allow {
	ports = split(port, ",")
	sublist = split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= 3389
	to_number(trim(sublist[1], " ")) >= 3389
	allow = true
}

isRelevantAddressPrefix(prefix) = allow {
	prefix == "*"
	allow = true
}

else = allow {
	prefix == "0.0.0.0"
	allow = true
}

else = allow {
	endswith(prefix, "/0")
	allow = true
}

else = allow {
	prefix == "internet"
	allow = true
}

else = allow {
	prefix == "any"
	allow = true
}
