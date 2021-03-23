package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_group := task[modules[m]]
	ansLib.checkState(ec2_group)
	rule := ec2_group.rules[index]

	rule.from_port == 0
	rule.to_port == 0

	not isValidProto(rule.proto)
	isEntireNetwork(rule.cidr_ip)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] is restricted", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] is not restricted", [index]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_group := task[modules[m]]
	ansLib.checkState(ec2_group)
	rule := ec2_group.rules[index]

	rule.from_port == 0
	rule.to_port == 0

	not isValidProto(rule.proto)
	isEntireNetwork(rule.cidr_ipv6)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] is restricted", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] is not restricted", [index]),
	}
}

isEntireNetwork(cidr) {
	is_array(cidr)
	cidrs = {"0.0.0.0/0", "::/0"}
	count({x | cidr[x]; cidr[x] == cidrs[j]}) != 0
}

isEntireNetwork(cidr) {
	is_string(cidr)
	cidrs = {"0.0.0.0/0", "::/0"}
	cidr == cidrs[j]
}

isValidProto(proto) {
	is_string(proto)
	protos = {"tcp", "udp", "icmp", "icmpv6"}
	proto == protos[j]
}

isValidProto(proto) {
	is_number(proto)
	protos = {1, 6, 17, 58}
	proto == protos[j]
}
