package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sts_assume_role", "sts_assume_role"}
	sts_assume_role := task[modules[m]]
	ansLib.checkState(sts_assume_role)
	attributes := {"mfa_serial_number", "mfa_token"}

	object.get(sts_assume_role, attributes[j], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("sts_assume_role.%s is set", [attributes[j]]),
		"keyActualValue": sprintf("sts_assume_role.%s is undefined", [attributes[j]]),
	}
}
