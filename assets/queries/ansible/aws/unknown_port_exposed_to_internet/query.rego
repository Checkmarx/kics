package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_group := task[modules[m]]
	ansLib.checkState(ec2_group)
	rule := ec2_group.rules[index]

	not portIsKnown(rule.from_port)
	isEntireNetwork(rule)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d].from_port is known", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d].from_port is unknown and is exposed to the entire Internet", [index]),
	}
}

portIsKnown(port) {
	knownPorts := [
		0, 20, 21, 22, 23, 25, 53, 57, 80, 88, 110, 119, 123, 135, 143, 137, 138, 139,
		161, 162, 163, 164, 194, 318, 443, 514, 563, 636, 989, 990, 1433, 1434,
		2382, 2383, 2484, 3000, 3020, 3306, 3389, 4505, 4506, 5060, 5353, 5432,
		5500, 5900, 7001, 8000, 8080, 8140, 9000, 9200, 9300, 11214, 11215, 27017,
		27018, 61621,
	]

	commonLib.inArray(knownPorts, port)
}

isEntireNetwork(rule) {
	ansLib.isEntireNetwork(rule.cidr_ip)
}

isEntireNetwork(rule) {
	ansLib.isEntireNetwork(rule.cidr_ipv6)
}
