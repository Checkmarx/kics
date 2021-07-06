package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.iam_group", "iam_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	iam_group := task[modules[m]]
	ansLib.checkState(iam_group)

	info := without_users(iam_group, task.name, modules[m])

	result := {
		"documentId": id,
		"searchKey": info.searchKey,
		"issueType": info.issueType,
		"keyExpectedValue": sprintf("%s.users is %s", [modules[m], info.value]),
		"keyActualValue": sprintf("%s.users is not %s", [modules[m], info.value]),
	}
}

without_users(iam_group, name, module) = info {
	object.get(iam_group, "users", "undefined") == "undefined"
	searchKey := sprintf("name={{%s}}.{{%s}}", [name, module])
	info := {"searchKey": searchKey, "issueType": "MissingAttribute", "value": "set"}
} else = info {
	iam_group.users == null
	searchKey := sprintf("name={{%s}}.{{%s}}.users", [name, module])
	info := {"searchKey": searchKey, "issueType": "IncorrectValue", "value": "empty"}
}
