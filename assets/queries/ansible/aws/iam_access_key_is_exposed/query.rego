package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task = ansLib.tasks[id][t]
	iamuser = task["community.aws.iam"]

	lower(iamuser.access_key_state) == "active"
	not contains(lower(iamuser.name), "root")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam}}.access_key_state", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}}.{{community.aws.iam}}.name is 'root' for an active access key", [task.name]),
		"keyActualValue": sprintf("{{%s}}.{{community.aws.iam}}.name is '%s' for an active access key", [task.name, iamuser.name]),
	}
}
