package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.ec2_group", "ec2_group"}
	group := task[modules[m]]
	ansLib.checkState(group)

	searchKey := getCidrBlock(group)

	splitted := regex.split("{{|}}", searchKey)
	errorPath := substring(splitted[0], 0, count(splitted[0]) - 1)
	errorValue := splitted[1]

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], searchKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.%s should not contain the value '%s'", [errorPath, errorValue]),
		"keyActualValue": sprintf("ec2_group.%s contains value '%s'", [errorPath, errorValue]),
	}
}

getCidrBlock(sg) = path {
	hasDefinedPorts(sg.rules[r])
	isUnsafeIp(sg.rules[r].cidr_ip)
	path := "rules.cidr_ip={{0.0.0.0/0}}"
} else = path {
	hasDefinedPorts(sg.rules[r])
	isUnsafeIp(sg.rules[r].cidr_ip[c])
	path := "rules.cidr_ip.{{0.0.0.0/0}}"
} else = path {
	hasDefinedPorts(sg.rules[r])
	isUnsafeIpv6(sg.rules[r].cidr_ipv6)
	path := "rules.cidr_ipv6={{::/0}}"
} else = path {
	hasDefinedPorts(sg.rules[r])
	isUnsafeIpv6(sg.rules[r].cidr_ipv6[c])
	path := "rules.cidr_ipv6.{{::/0}}"
}

hasDefinedPorts(rule) {
	rule.from_port
	rule.to_port
} else {
	rule.ports
}

isUnsafeIp("0.0.0.0/0") = true

isUnsafeIpv6("::/0") = true
