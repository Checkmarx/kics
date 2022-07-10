package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.iam", "iam"}
	iam := task[modules[m]]
	ansLib.checkState(iam)

	is_string(iam.access_key_state)
	lower(iam.access_key_state) == "active"
	iam.iam_type == "user"
	is_string(iam.name)
	contains(lower(iam.name), "root")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam should not be active for a root account",
		"keyActualValue": "iam is active for a root account",
	}
}
