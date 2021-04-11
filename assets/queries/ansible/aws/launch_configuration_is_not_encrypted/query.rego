package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.ec2_lc", "ec2_lc"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	object.get(ec2_lc, "volumes", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ec2_lc.volumes is set",
		"keyActualValue": "ec2_lc.volumes is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	object.get(ec2_lc.volumes[j], "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.volumes", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("ec2_lc.volumes[%d].encrypted is set", [j]),
		"keyActualValue": sprintf("ec2_lc.volumes[%d].encrypted is undefined", [j]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	object.get(ec2_lc.volumes[j], "ephemeral", "undefined") == "undefined"
	ansLib.isAnsibleFalse(ec2_lc.volumes[j].encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.volumes", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_lc.volumes[%d].encrypted is set to true or yes", [j]),
		"keyActualValue": sprintf("ec2_lc.volumes[%d].encrypted is not set to true or yes", [j]),
	}
}
