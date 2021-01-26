package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	awsEc2 := task["amazon.aws.ec2_group"]
	rules := awsEc2.rules[j]
	port := rules.ports[k]
	rules.cidr_ip == "0.0.0.0/0"
	rules.proto == "tcp"
	portNumber := 2383
	port == portNumber

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.cidr_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.cidr_ip is not public", [task.name]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.cidr_ip is public", [task.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	awsEc2 := task["amazon.aws.ec2_group"]
	rules := awsEc2.rules[j]
	port := ["to_port", "from_port"]
	rules[port[z]] == -1
	rules.proto == "tcp"
	rules.cidr_ip == "0.0.0.0/0"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s", [task.name, port[z]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s is different than -1 (all ports are open)", [task.name, port[z]]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s is -1 (all ports are open)", [task.name, port[z]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	awsEc2 := task["amazon.aws.ec2_group"]
	rules := awsEc2.rules[j]
	rules.proto == "tcp"
	rules.cidr_ip == "0.0.0.0/0"
	checkRange(rules.to_port, rules.from_port)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules 'from_port' - 'to_port' range does not contain port 2383", [task.name]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s 'from_port' - 'to_port' range contains port 2383", [task.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	awsEc2 := task["amazon.aws.ec2_group"]
	rules := awsEc2.rules[j]
	rules.proto == "tcp"
	rules.cidr_ip == "0.0.0.0/0"
	contains(rules.ports[w], "-")
	aux := split(rules.ports[w], "-")
	checkRange(to_number(trim_space(aux[1])), to_number(trim_space(aux[0])))

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s", [task.name, rules.ports[w]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s range does not contain port '2383'", [task.name, rules.ports[w]]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.%s range contains port '2383'", [task.name, rules.ports[w]]),
	}
}

checkRange(to_port, from_port) {
	to_port >= 2383
	from_port <= 2383
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
