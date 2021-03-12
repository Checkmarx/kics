package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_instance = task[modules[m]]
	ansLib.checkState(ec2_instance)

	count(ec2_instance.rules) > 0
	elements := {elem | elem := ec2_instance.rules[j]; not checkPrivateIps(ec2_instance.rules[j].cidr_ip)}
	count(elements) > 0
	values := concat(",", {e | e := elements[p].cidr_ip; true})

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules.cidr_ip", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ec2_group.rules.cidr_ip' is one of [10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12]",
		"keyActualValue": sprintf("'ec2_group.rules.cidr_ip' is [%s]", [values]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_instance = task[modules[m]]
	ansLib.checkState(ec2_instance)

	elements := {elem | elem := ec2_instance.rules_egress[j]; not checkPrivateIps(ec2_instance.rules_egress[j].cidr_ip)}
	count(elements) > 0
	values := concat(",", {e | e := elements[p].cidr_ip; true})

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules_egress.cidr_ip", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ec2_group.rules_egress.cidr_ip' is one of [10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12]",
		"keyActualValue": sprintf("'ec2_group.rules_egress.cidr_ip' is [%s]", [values]),
	}
}

checkPrivateIps(ipVal) = result {
	private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
	result := net.cidr_contains(private_ips[_], ipVal)
}
