package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"amazon.aws.ec2_vol", "ec2_vol"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_vol := task[modules[m]]
	checkState(ec2_vol)

	ansLib.isAnsibleFalse(ec2_vol.encrypted)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encrypted", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2_vol.encrypted should be enabled",
		"keyActualValue": "ec2_vol.encrypted is disabled",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_vol := task[modules[m]]
	checkState(ec2_vol)

	not common_lib.valid_key(ec2_vol, "encrypted")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ec2_vol.encrypted should be defined",
		"keyActualValue": "ec2_vol.encrypted is undefined",
	}
}

checkState(task) {
	state := object.get(task, "state", "undefined")
	state != "absent"
	state != "list"
}
