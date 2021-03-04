package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	fs := task["community.aws.efs"]

	object.get(fs, "encrypt", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.efs}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.efs.encrypt should be set to true",
		"keyActualValue": "community.aws.efs.encrypt is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	fs := task["community.aws.efs"]

	not ansLib.isAnsibleTrue(fs.encrypt)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.efs}}.encrypt", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.efs.encrypt should be set to true",
		"keyActualValue": "community.aws.efs.encrypt is set to false",
	}
}
