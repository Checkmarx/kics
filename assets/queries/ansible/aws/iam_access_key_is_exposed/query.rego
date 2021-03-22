package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.iam", "iam"}
	iamuser := task[modules[m]]
	ansLib.checkState(iamuser)

	lower(iamuser.access_key_state) == "active"
	not contains(lower(iamuser.name), "root")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.access_key_state", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam.name is 'root' for an active access key",
		"keyActualValue": sprintf("iam.name is '%s' for an active access key", [iamuser.name]),
	}
}
