package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	iam := task["community.aws.iam"]

	is_string(iam.access_key_state)
	lower(iam.access_key_state) == "active"
	iam.iam_type == "user"
	is_string(iam.name)
	contains(lower(iam.name), "root")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam}}", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam is not active for a root account",
		"keyActualValue": "community.aws.iam is active for a root account",
	}
}
