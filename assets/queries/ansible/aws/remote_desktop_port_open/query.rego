package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	fromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	toPort := task["amazon.aws.ec2_group"].rules[index].to_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	fromPort != -1
	fromPort <= portNumber
	toPort >= portNumber

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	ports := task["amazon.aws.ec2_group"].rules[index].ports
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	ports == portNumber

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	ports := task["amazon.aws.ec2_group"].rules[index].ports
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	mports := split(ports, "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	ports := task["amazon.aws.ec2_group"].rules[index].ports[_]
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	mports := split(ports, "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	ports := task["amazon.aws.ec2_group"].rules[index].ports[_]
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	ports == portNumber

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.ports opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	fromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	fromPort == -1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.from_port", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.from_port doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.from_port opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_group"].publicly_accessible)
	toPort := task["amazon.aws.ec2_group"].rules[index].to_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip
	cidr == "0.0.0.0/0"
	portNumber := 3389
	toPort == -1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.to_port", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.to_port doesn't open the remote desktop port (%s)", [task.name, portNumber]),
		"keyActualValue": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules.to_port opens the remote desktop port (%s)", [task.name, portNumber]),
	}
}