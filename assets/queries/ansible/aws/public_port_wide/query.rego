package Cx

import data.generic.common as common_lib
import data.generic.ansible as ans_lib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	ec2_group := task[modules[m]]
	ans_lib.checkState(ec2_group)
	fromPort := ec2_group.rules[index].from_port
	toPort := ec2_group.rules[index].to_port

	toPort - fromPort > 0

	cidr := ec2_group.rules[index].cidr_ip
	ans_lib.isEntireNetwork(cidr)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] shouldn't have public port wide", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] has public port wide", [index]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "rules", index], []),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	ec2_group := task[modules[m]]
	ans_lib.checkState(ec2_group)
	fromPort := ec2_group.rules[index].from_port
	toPort := ec2_group.rules[index].to_port

	toPort - fromPort > 0

	cidr := ec2_group.rules[index].cidr_ipv6
	ans_lib.isEntireNetwork(cidr)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] shouldn't have public port wide", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] has public port wide", [index]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "rules", index], []),
	}
}
