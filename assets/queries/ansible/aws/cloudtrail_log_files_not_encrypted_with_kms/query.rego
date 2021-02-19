package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	modules := {"community.aws.cloudtrail", "cloudtrail"}

	object.get(task[modules[index]], "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.kms_key_id is set", [modules[index]]),
		"keyActualValue": sprintf("%s.kms_key_id is undefined", [modules[index]]),
	}
}
