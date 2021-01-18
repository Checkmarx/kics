package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	fromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	toPort := task["amazon.aws.ec2_group"].rules[index].to_port

	toPort - fromPort > 0

	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	isEntireNetwork(cidr)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.ec2_group.rules[%d] doesn't have public port wide", [index]),
		"keyActualValue": sprintf("amazon.aws.ec2_group.rules[%d] has public port wide", [index]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	fromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	toPort := task["amazon.aws.ec2_group"].rules[index].to_port

	toPort - fromPort > 0

	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ipv6
	isEntireNetwork(cidr)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.ec2_group.rules[%d] doesn't have public port wide", [index]),
		"keyActualValue": sprintf("amazon.aws.ec2_group.rules[%d] has public port wide", [index]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isEntireNetwork(cidr) = allow {
	isArray := is_array(cidr)

	cidrs = {"0.0.0.0/0", "::/0"}

	count({x | cidr[x]; cidr[x] == cidrs[j]}) != 0

	allow = true
}

isEntireNetwork(cidr) = allow {
	isString := is_string(cidr)

	cidrs = {"0.0.0.0/0", "::/0"}
	cidr == cidrs[j]

	allow = true
}
