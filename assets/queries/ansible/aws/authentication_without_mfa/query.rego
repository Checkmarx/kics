package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sts_assume_role", "sts_assume_role"}
	sts_assume_role := task[modules[m]]
	ansLib.checkState(sts_assume_role)
	attributes := {"mfa_serial_number", "mfa_token"}

	not common_lib.valid_key(sts_assume_role, attributes[j])

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("sts_assume_role.%s should be set", [attributes[j]]),
		"keyActualValue": sprintf("sts_assume_role.%s is undefined", [attributes[j]]),
	}
}
