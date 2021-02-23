package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	fs := task["community.aws.efs"]
	fsName := task.name

	object.get(fs, "encrypt", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.efs}}", [fsName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.efs.encrypt should be set to true",
		"keyActualValue": "community.aws.efs.encrypt is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	fs := task["community.aws.efs"]
	fsName := task.name

	not ansLib.isAnsibleTrue(fs.encrypt)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.efs}}.encrypt", [fsName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.efs.encrypt should be set to true",
		"keyActualValue": "community.aws.efs.encrypt is set to false",
	}
}