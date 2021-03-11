package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2Ami := task["amazon.aws.ec2_ami"]
	devMap := ec2Ami.device_mapping

	object.get(devMap, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_ami}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.ec2_ami.device_mapping.device_name.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_ami.device_mapping.device_name.encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2Ami := task["amazon.aws.ec2_ami"]
	devMap := ec2Ami.device_mapping

	not ansLib.isAnsibleTrue(devMap.encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_ami}}.device_mapping.encrypted", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "amazon.aws.ec2_ami.device_mapping.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_ami.device_mapping.encrypted is set to false",
	}
}
