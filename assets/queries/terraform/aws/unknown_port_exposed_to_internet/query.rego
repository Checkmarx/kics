package Cx

import data.generic.terraform as tf_lib
import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	ingress := getIngressList(resource.ingress)
	cidr := ingress[j].cidr_blocks

	unknownPort(ingress[j].from_port, ingress[j].to_port)
	isEntireNetwork(cidr)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress ports are known", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress ports are unknown and exposed to the entire Internet", [name]),
		"searchLine": commonLib.build_search_line(["resource", "aws_security_group", name, "ingress", j, "cidr_blocks"], []),
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

unknownPort(from_port,to_port) {
	port := numbers.range(from_port, to_port)[i]
	not commonLib.valid_key(commonLib.tcpPortsMap, port)
}

isEntireNetwork(cidr) = allow {
	count({x | cidr[x]; cidr[x] == "0.0.0.0/0"}) != 0
	allow = true
}
