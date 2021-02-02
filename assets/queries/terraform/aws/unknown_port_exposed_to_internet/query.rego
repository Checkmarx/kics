package Cx

portIsKnown(port, knownPorts) = allow {
	count({x | knownPorts[x]; knownPorts[x] == port}) != 0

	allow = true
}

isEntireNetwork(cidr) = allow {
	count({x | cidr[x]; cidr[x] == "0.0.0.0/0"}) != 0

	allow = true
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name].ingress
	currentPort := resource.from_port
	cidr := resource.cidr_blocks

	knownPorts := [
		0, 20, 21, 22, 23, 25, 53, 57, 80, 88, 110, 119, 123, 135, 143, 137, 138, 139,
		161, 162, 163, 164, 194, 318, 443, 514, 563, 636, 989, 990, 1433, 1434,
		2382, 2383, 2484, 3000, 3020, 3306, 3389, 4505, 4506, 5060, 5353, 5432,
		5500, 5900, 7001, 8000, 8080, 8140, 9000, 9200, 9300, 11214, 11215, 27017,
		27018, 61621,
	]

	not portIsKnown(currentPort, knownPorts)
	isEntireNetwork(cidr)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress.from_port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.from_port is known", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.from_port is unknown and is exposed to the entire Internet", [name]),
	}
}
