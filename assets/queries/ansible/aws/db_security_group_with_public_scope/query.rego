package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_instance = task.ec2_group

	count(ec2_instance.rules) > 0
	elements := {elem | elem := ec2_instance.rules[j]; isPublicScope(ec2_instance.rules[j].cidr_ip)}
	count(elements) > 0
	values := concat(",", {e | e := elements[p].cidr_ip; true})

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.rules.cidr_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name={{%s}}.rules.cidr_ip' is one of [10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12]", [task.name]),
		"keyActualValue": sprintf("'name={{%s}}.rules.cidr_ip' is [%s]", [task.name, values]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_instance = task.ec2_group

	elements := {elem | elem := ec2_instance.rules_egress[j]; isPublicScope(ec2_instance.rules_egress[j].cidr_ip)}
	count(elements) > 0
	values := concat(",", {e | e := elements[p].cidr_ip; true})

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.rules_egress.cidr_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name={{%s}}.rules_egress.cidr_ip' is one of [10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12]", [task.name]),
		"keyActualValue": sprintf("'name={{%s}}.rules_egress.cidr_ip' is [%s]", [task.name, values]),
	}
}

isPublicScope("0.0.0.0/0") = true
