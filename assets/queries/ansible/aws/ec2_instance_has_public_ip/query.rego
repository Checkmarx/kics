package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	ipValue := task["amazon.aws.ec2"].assign_public_ip
	HasPublicIP(ipValue)

	# There is no default value for assign_public_ip

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2}}.assign_public_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2}}.assign_public_ip is false, 'no' or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.ec2}}.assign_public_ip is '%s'", [task.name, ipValue]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	ipValue := task["community.aws.ec2_launch_template"].network_interfaces.associate_public_ip_address
	HasPublicIP(ipValue)

	# There is no default value for associate_public_ip_address

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ec2_launch_template}}.network_interfaces.associate_public_ip_address", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_launch_template}}.network_interfaces.associate_public_ip_address is false, 'no' or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.ec2_launch_template}}.network_interfaces.associate_public_ip_address is '%s'", [task.name, ipValue]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	ipValue := task["community.aws.ec2_instance"].network.assign_public_ip
	HasPublicIP(ipValue)

	# There is no default value for assign_public_ip

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ec2_instance}}.network.assign_public_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_instance}}.network.assign_public_ip is false, 'no' or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.ec2_instance}}.network.assign_public_ip is '%s'", [task.name, ipValue]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

HasPublicIP(value) {
	lower(value) == "yes"
} else {
	lower(value) == "true"
} else {
	value == true
}
