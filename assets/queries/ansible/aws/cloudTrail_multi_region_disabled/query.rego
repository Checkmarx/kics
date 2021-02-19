package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudtrail"].publicly_accessible)
	isAnsibleFalse(task["community.aws.cloudtrail"].is_multi_region_trail)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.cloudtrail}}.is_multi_region_trail", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{community.aws.cloudtrail}}.is_multi_region_trail is true", [task.name]),
		"keyActualValue": sprintf("name={{%s}}.{{community.aws.cloudtrail}}.is_multi_region_trail is false", [task.name]),
	}
}

isAnsibleFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
