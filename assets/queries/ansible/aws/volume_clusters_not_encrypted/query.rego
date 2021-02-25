package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	volume := task["amazon.aws.ec2_vol"]

	object.get(volume, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_vol}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.ec2_vol.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_vol.encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	volume := task["amazon.aws.ec2_vol"]

	not ansLib.isAnsibleTrue(volume.encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_vol}}.encrypt", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.ec2_vol.encrypted should be set to true",
		"keyActualValue": "amazon.aws.ec2_vol.encrypted is set to false",
	}
}
