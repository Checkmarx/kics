package Cx

isTCP(protocol) = allow {
    upper(protocol) == "TCP"
    allow = true
}
else = allow {
    upper(protocol) == "*"
	allow = true
}

containsPort(port, portList) = allow {
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), portList)
    allow = true
}
else = allow {
	ports = split(portList, ",")
    sublist = split(ports[var],"-")
    to_number(trim(sublist[0]," ")) <= port
    to_number(trim(sublist[1]," ")) >= port
	allow = true
}

isEntireNetwork(prefix) = allow {
                endswith(prefix, "/0")
                allow = true
}


CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_network_security_rule[var0]
    upper(resource.access) == "ALLOW"

    portNumber = 138
	containsPort(portNumber, resource.destination_port_range)
    isTCP(resource.protocol)
    isEntireNetwork(resource.source_address_prefix)
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_network_security_rule[%s].destination_port_range", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_network_security_rule.%s.destination_port_range' cannot be %d", [var0, portNumber]),
                "keyActualValue": 	sprintf("'azurerm_network_security_rule.%s.destination_port_range' might be %d", [var0, portNumber])
              }
}
