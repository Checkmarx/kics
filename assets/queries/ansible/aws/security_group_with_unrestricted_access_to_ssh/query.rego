package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_group := task[modules[m]]
	ansLib.checkState(ec2_group)
	rule := ec2_group.rules[index]

	isSSH(rule.from_port, rule.to_port)
	publicRule(rule)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] SSH' (Port:22) should not be public", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] SSH' (Port:22) is public", [index]),
	}
}

isSSH(currentFromPort, currentToPort) {
	currentFromPort <= 22
	currentToPort >= 22
}

isSSH(currentFromPort, currentToPort) {
	currentFromPort == -1
	currentToPort == -1
}

publicRule(rule) {
	not isPrivate(rule.cidr_ip)
}

publicRule(rule) {
	not isPrivate(rule.cidr_ipv6)
}

isPrivate(cidr) {
	is_array(cidr)
	privateIPs = ["192.120.0.0/16", "75.132.0.0/16", "79.32.0.0/8", "64:ff9b::/96", "2607:F8B0::/32"]
	cidrLength := count(cidr)
	count({x | cidr[x]; cidr[x] == privateIPs[j]}) == cidrLength
}

isPrivate(cidr) {
	is_string(cidr)
	privateIPs = ["192.120.0.0/16", "75.132.0.0/16", "79.32.0.0/8", "64:ff9b::/96", "2607:F8B0::/32"]
	cidr == privateIPs[j]
}
