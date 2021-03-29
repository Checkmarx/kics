package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

getProtocol(resource) = protocol {
	protocol := resource.protocol
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

isAccessibleFromEntireNetwork(resource) = accessible {
	endswith(resource.source_address_prefix, "/0")
	accessible := true
}

isAllowed(resource) = allowed {
	upper(resource.access) == "ALLOW"
	allowed := true
}

isTCPorUDP(protocol) = is {
	is := upper(protocol) != "ICMP"
}

CxPolicy[result] {
	#############	inputs
	tcpPortsMap := commonLib.tcpPortsMap

	#############	document and resource
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_securitygroup", "azure_rm_securitygroup"}
	securitygroup := task[modules[m]]
	ansLib.checkState(securitygroup)
	resource := securitygroup.rules[r]
	ruleName := resource.name

	#############	get relevant fields
	portContent := tcpPortsMap[port]
	portNumber = port
	portName = portContent
	protocolList := getProtocolList(getProtocol(resource))
	protocol := protocolList[k]

	#############	Checks
	isAllowed(resource)
	isAccessibleFromEntireNetwork(resource)
	containsDestinationPort(portNumber, resource)
	isTCPorUDP(protocol)

	#############	Result
	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules.name={{%s}}.destination_port_range", [task.name, modules[m], ruleName]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s.azure_rm_securitygroup.rules", [portName, protocol, portNumber, ruleName]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in %s.azure_rm_securitygroup.rules", [portName, protocol, portNumber, ruleName]),
	}
}
