package Cx

import data.generic.terraform as tf_lib
port_fields := ["destination_port_ranges","destination_port_range"]

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_security_rule[var0]
	upper(resource.access) == "ALLOW"
	upper(resource.direction) == "INBOUND"

	isRelevantProtocol(resource.protocol)
	isRelevantPort(resource[port_fields[i2]])
	isRelevantAddressPrefix(resource.source_address_prefix)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_security_rule",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_network_security_rule[%s].%s", [var0,port_fields[i2]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_security_rule.%s.%s' cannot be 22", [var0,port_fields[i2]]),
		"keyActualValue": sprintf("'azurerm_network_security_rule.%s.%s' might be 22", [var0,port_fields[i2]]),
	}
}

CxPolicy[result] {
  group := input.document[i].resource.azurerm_network_security_group[groupName]
  rule := group.security_rule[idx]

  upper(rule.access) == "ALLOW"
  upper(rule.direction) == "INBOUND"

  isRelevantProtocol(rule.protocol)
  isRelevantPort(rule[port_fields[i2]])
  isRelevantAddressPrefix(rule.source_address_prefix)

  result := {
    "documentId": input.document[i].id,
    "resourceType": "azurerm_network_security_group",
    "resourceName": tf_lib.get_resource_name(rule, [groupName, "security_rule", idx]),
    "searchKey": sprintf("azurerm_network_security_group[%s].security_rule.name={{%s}}.%s", [groupName, rule.name,port_fields[i2]]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("'%s' cannot be 22", [port_fields[i2]]),
    "keyActualValue": sprintf("'%s' might be 22", [port_fields[i2]]),
  }
}

isRelevantProtocol(protocol) = true {
	upper(protocol) != "UDP"
	upper(protocol) != "ICMP"
}

isRelevantPort(port) = true {
	regex.match("(^|\\s|,)22(-|,|$|\\s)", port)
} else = true {
	ports = split(port, ",")
	sublist = split(ports[i], "-")
	to_number(trim(sublist[0], " ")) <= 22
	to_number(trim(sublist[1], " ")) >= 22
} else = true {
	regex.match("(^|\\s|,)22(-|,|$|\\s)", port[i])
} else = true {
	sublist = split(port[i], "-")
	to_number(trim(sublist[0], " ")) <= 22
	to_number(trim(sublist[1], " ")) >= 22
}

isRelevantAddressPrefix(prefix) = true {
	prefix == "*"
} else = true {
	prefix == "0.0.0.0"
} else = true {
	endswith(prefix, "/0")
} else = true {
	prefix == "internet"
} else = true {
	prefix == "any"
}