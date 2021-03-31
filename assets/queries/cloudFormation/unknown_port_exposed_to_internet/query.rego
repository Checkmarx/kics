package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	rule := resource.Properties.SecurityGroupIngress[index]

	entireNetwork(rule)
	containsUnknownPort(rule)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] doesn't open unknown ports to the Internet", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] opens unknown ports to the Internet", [name, index]),
	}
}

knownPorts := [
	0, 20, 21, 22, 23, 25, 53, 57, 80, 88, 110, 119, 123, 135, 143, 137, 138, 139,
	161, 162, 163, 164, 194, 318, 443, 514, 563, 636, 989, 990, 1433, 1434,
	2382, 2383, 2484, 3000, 3020, 3306, 3389, 4505, 4506, 5060, 5353, 5432,
	5500, 5900, 7001, 8000, 8080, 8140, 9000, 9200, 9300, 11214, 11215, 27017,
	27018, 61621,
]

containsUnknownPort(rule) {
	not commonLib.inArray(knownPorts, rule.FromPort)
} else {
	not commonLib.inArray(knownPorts, rule.ToPort)
} else {
	some i
	port := numbers.range(rule.FromPort, rule.ToPort)[i]
	not commonLib.inArray(knownPorts, port)
}

entireNetwork(rule) {
	rule.CidrIp == "0.0.0.0/0"
}

entireNetwork(rule) {
	rule.CidrIpv6 == "::/0"
}
