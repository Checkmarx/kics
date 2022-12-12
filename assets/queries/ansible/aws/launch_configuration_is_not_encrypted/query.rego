package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.ec2_lc", "ec2_lc"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	not common_lib.valid_key(ec2_lc, "volumes")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ec2_lc.volumes should be set",
		"keyActualValue": "ec2_lc.volumes is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	volume := ec2_lc.volumes[j]
	not common_lib.valid_key(volume, "encrypted")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.volumes", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("ec2_lc.volumes[%d].encrypted should be set", [j]),
		"keyActualValue": sprintf("ec2_lc.volumes[%d].encrypted is undefined", [j]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_lc := task[modules[m]]
	ansLib.checkState(ec2_lc)

	volume := ec2_lc.volumes[j]
	not common_lib.valid_key(volume, "ephemeral")
	ansLib.isAnsibleFalse(ec2_lc.volumes[j].encrypted)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.volumes", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_lc.volumes[%d].encrypted should be set to true or yes", [j]),
		"keyActualValue": sprintf("ec2_lc.volumes[%d].encrypted is not set to true or yes", [j]),
	}
}
