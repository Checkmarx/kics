package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	checkState(object.get(ec2, "state", "undefined"))

	ansLib.isAnsibleTrue(ec2.assign_public_ip)

	# There is no default value for assign_public_ip

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.assign_public_ip", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2.assign_public_ip is false, 'no' or undefined",
		"keyActualValue": sprintf("ec2.assign_public_ip is '%s'", [ec2.assign_public_ip]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_launch_template", "ec2_launch_template"}
	ec2_launch_template := task[modules[m]]
	ansLib.checkState(ec2_launch_template)

	ipValue := ec2_launch_template.network_interfaces.associate_public_ip_address
	ansLib.isAnsibleTrue(ipValue)

	# There is no default value for associate_public_ip_address

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_interfaces.associate_public_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2_launch_template.network_interfaces.associate_public_ip_address is false, 'no' or undefined",
		"keyActualValue": sprintf("ec2_launch_template.network_interfaces.associate_public_ip_address is '%s'", [ipValue]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_instance", "ec2_instance"}
	ec2_instance := task[modules[m]]
	checkState(object.get(ec2_instance, "state", "undefined"))

	ipValue := ec2_instance.network.assign_public_ip
	ansLib.isAnsibleTrue(ipValue)

	# There is no default value for assign_public_ip

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network.assign_public_ip", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2_instance.network.assign_public_ip is false, 'no' or undefined",
		"keyActualValue": sprintf("ec2_instance.network.assign_public_ip is '%s'", [ipValue]),
	}
}

checkState("undefined") = true

checkState("present") = true
