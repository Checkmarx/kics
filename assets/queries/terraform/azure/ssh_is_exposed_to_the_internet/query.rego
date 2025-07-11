package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_security_rule[var0]
	upper(resource.access) == "ALLOW"
	upper(resource.direction) == "INBOUND"

	isRelevantProtocol(resource.protocol)
	isRelevantPort(resource.destination_port_range)
	isRelevantAddressPrefix(resource.source_address_prefix)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_security_rule",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_network_security_rule[%s].destination_port_range", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_security_rule.%s.destination_port_range' cannot be 22", [var0]),
		"keyActualValue": sprintf("'azurerm_network_security_rule.%s.destination_port_range' might be 22", [var0]),
	}
}

CxPolicy[result] {
  group := input.document[i].resource.azurerm_network_security_group[groupName]
  rule := group.security_rule[idx]

  upper(rule.access) == "ALLOW"
  upper(rule.direction) == "INBOUND"

  isRelevantProtocol(rule.protocol)
  isRelevantPort(rule.destination_port_range)
  isRelevantAddressPrefix(rule.source_address_prefix)

  result := {
    "documentId": input.document[i].id,
    "resourceType": "azurerm_network_security_group",
    "resourceName": tf_lib.get_resource_name(rule, [groupName, "security_rule", idx]),
    "searchKey": sprintf("azurerm_network_security_group[%s].security_rule.name={{%s}}.destination_port_range", [groupName, rule.name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "'destination_port_range' cannot be 22",
    "keyActualValue": "'destination_port_range' might be 22",
  }
}

isRelevantProtocol(protocol) = allow {
	upper(protocol) != "UDP"
	upper(protocol) != "ICMP"
	allow = true
}

isRelevantPort(port) = allow {
	regex.match("(^|\\s|,)22(-|,|$|\\s)", port)
	allow = true
}

else = allow {
	ports = split(port, ",")
	sublist = split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= 22
	to_number(trim(sublist[1], " ")) >= 22
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
