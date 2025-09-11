package Cx

import data.generic.common as common_lib
import data.generic.ansible as ans_lib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	ec2_group := task[modules[m]]
	ans_lib.checkState(ec2_group)
	cidr_fields := ["cidr_ip", "cidr_ipv6"]
	rule := ec2_group.rules[index]

	rule.from_port == 0
	rule.to_port == 0

	not isValidProto(rule.proto)
	ans_lib.isEntireNetwork(rule[cidr_fields[_]])

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] should be restricted", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] is not restricted", [index]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "rules", index], []),
	}
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
