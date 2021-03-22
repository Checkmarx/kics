package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.ec2_ami", "ec2_ami"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2Ami := task[modules[m]]
	ansLib.checkState(ec2Ami)

	object.get(ec2Ami.device_mapping, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ec2_ami.device_mapping.device_name.encrypted should be set to true",
		"keyActualValue": "ec2_ami.device_mapping.device_name.encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2Ami := task[modules[m]]
	ansLib.checkState(ec2Ami)

	not ansLib.isAnsibleTrue(ec2Ami.device_mapping.encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.device_mapping.encrypted", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2_ami.device_mapping.encrypted should be set to true",
		"keyActualValue": "ec2_ami.device_mapping.encrypted is set to false",
	}
}
