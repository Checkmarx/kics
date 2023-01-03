package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	#############	inputs
	tcpPortsMap := commonLib.tcpPortsMap

	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_securitygroup", "azure_rm_securitygroup"}
	securitygroup := task[modules[m]]
	ansLib.checkState(securitygroup)
	resource := securitygroup.rules[r]

	portContent := tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocol := getProtocolList(resource.protocol)[_]

	upper(resource.access) == "ALLOW"
	inbound_direction(resource)
	endswith(resource.source_address_prefix, "/0")
	containsDestinationPort(portNumber, resource)
	isTCPorUDP(protocol)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules.name={{%s}}.destination_port_range", [task.name, modules[m], resource.name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
	}
}

getProtocolList(protocol) = list {
	protocol == "*"
	list := ["TCP", "UDP", "Icmp"]
}

else = list {
	upper(protocol) == "TCP"
	list := ["TCP"]
}

else = list {
	upper(protocol) == "UDP"
	list := ["UDP"]
}

else = list {
	upper(protocol) == "ICMP"
	list := ["Icmp"]
}

containsDestinationPort(port, resource) = containing {
	is_string(resource.destination_port_range)
	containing := containsDP(port, resource.destination_port_range)
}

else = containing {
	is_array(resource.destination_port_range)
	containing := containsDP(port, resource.destination_port_range[i])
}

containsDP(port, dpr) = containing {
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), dpr)
	containing := true
}

else = containing {
	ports = split(dpr, ",")
	sublist = split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= port
	to_number(trim(sublist[1], " ")) >= port
	containing := true
}

isTCPorUDP(protocol) = is {
	is := upper(protocol) != "ICMP"
}

inbound_direction(resource){
	upper(resource.direction) == "INBOUND"
}else{
	not commonLib.valid_key(resource,"direction")
}
