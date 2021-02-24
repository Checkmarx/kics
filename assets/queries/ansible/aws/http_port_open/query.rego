package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	fromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	toPort := task["amazon.aws.ec2_group"].rules[index].to_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	fromPort != -1
	fromPort <= portNumber
	toPort >= portNumber

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules opens the http port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ports := task["amazon.aws.ec2_group"].rules[index].ports
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	ports == portNumber

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the http port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ports := task["amazon.aws.ec2_group"].rules[index].ports
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	mports := split(ports, "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the http port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ports := task["amazon.aws.ec2_group"].rules[index].ports[_]
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	mports := split(ports, "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the http port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ports := task["amazon.aws.ec2_group"].rules[index].ports[_]
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	ports == portNumber

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the http port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	fromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	fromPort == -1

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.from_port", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.from_port doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.from_port opens the http port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	toPort := task["amazon.aws.ec2_group"].rules[index].to_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	cidr == "0.0.0.0/0"
	portNumber := 80
	toPort == -1

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.to_port", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.to_port doesn't open the http port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.to_port opens the http port (%s)", [task.name, portNumber]),
	}
}
