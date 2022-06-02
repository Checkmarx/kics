package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.efs", "efs"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	efs := task[modules[m]]
	ansLib.checkState(efs)

	not common_lib.valid_key(efs, "encrypt")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "efs.encrypt should be set to true",
		"keyActualValue": "efs.encrypt is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	efs := task[modules[m]]
	ansLib.checkState(efs)

	not ansLib.isAnsibleTrue(efs.encrypt)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encrypt", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "efs.encrypt should be set to true",
		"keyActualValue": "efs.encrypt is set to false",
	}
}
