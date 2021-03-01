package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ipValue := task["amazon.aws.ec2"].assign_public_ip
	ansLib.isAnsibleTrue(ipValue)

	# There is no default value for assign_public_ip

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2}}.assign_public_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2}}.assign_public_ip is false, 'no' or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.ec2}}.assign_public_ip is '%s'", [task.name, ipValue]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ipValue := task["community.aws.ec2_launch_template"].network_interfaces.associate_public_ip_address
	ansLib.isAnsibleTrue(ipValue)

	# There is no default value for associate_public_ip_address

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ec2_launch_template}}.network_interfaces.associate_public_ip_address", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_launch_template}}.network_interfaces.associate_public_ip_address is false, 'no' or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.ec2_launch_template}}.network_interfaces.associate_public_ip_address is '%s'", [task.name, ipValue]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ipValue := task["community.aws.ec2_instance"].network.assign_public_ip
	ansLib.isAnsibleTrue(ipValue)

	# There is no default value for assign_public_ip

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ec2_instance}}.network.assign_public_ip", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_instance}}.network.assign_public_ip is false, 'no' or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.ec2_instance}}.network.assign_public_ip is '%s'", [task.name, ipValue]),
	}
}
