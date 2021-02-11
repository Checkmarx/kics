package Cx

import data.generic.terraform as lib

portIsKnown(port, knownPorts) = allow {
	count({x | knownPorts[x][0]; knownPorts[x][0] == port}) != 0
	allow = true
}

isEntireNetwork(cidr) = allow {
	count({x | cidr[x]; cidr[x] == "0.0.0.0/0"}) != 0
	allow = true
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	ingress := getIngressList(resource.ingress)
	currentPort := ingress[j].from_port
	cidr := ingress[j].cidr_blocks

	not portIsKnown(currentPort, lib.portNumbers)
	isEntireNetwork(cidr)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.from_port is known", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.from_port is unknown and is exposed to the entire Internet", [name]),
	}
}

getIngressList(ingress) = list {
	is_array(ingress)
	list := ingress
} else = list {
	is_object(ingress)
	list := [ingress]
} else = null {
	true
}
