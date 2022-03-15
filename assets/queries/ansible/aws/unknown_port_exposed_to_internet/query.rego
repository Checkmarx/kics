package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_group := task[modules[m]]
	ansLib.checkState(ec2_group)
	rule := ec2_group.rules[index]

	unknownPort(rule.from_port,rule.to_port)
	isEntireNetwork(rule)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d].from_port is known", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d].from_port is unknown and is exposed to the entire Internet", [index]),
		"searchLine": commonLib.build_search_line(["playbooks", t, modules[m], "rules"], []),
	}
}


unknownPort(from_port,to_port) {
	port := numbers.range(from_port, to_port)[i]
	not commonLib.valid_key(commonLib.tcpPortsMap, port)
}

isEntireNetwork(rule) {
	ansLib.isEntireNetwork(rule.cidr_ip)
}

isEntireNetwork(rule) {
	ansLib.isEntireNetwork(rule.cidr_ipv6)
}
