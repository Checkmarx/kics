package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.ec2_group", "ec2_group"}
	ec2_instance = task[modules[m]]
	ansLib.checkState(ec2_instance)

	count(ec2_instance.rules) > 0
	elements := {elem | elem := ec2_instance.rules[j]; checkOver256(ec2_instance.rules[j].cidr_ip)}
	count(elements) > 0
	values := concat(",", {e | e := elements[p].cidr_ip; true})

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules.cidr_ip", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ec2_group.rules.cidr_ip' should be one of [10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12]",
		"keyActualValue": sprintf("'ec2_group.rules.cidr_ip' is [%s]", [values]),
	}
}

checkOver256(ipVal) {
	hosts := split(ipVal, "/")
	to_number(hosts[1]) <= 24
}
