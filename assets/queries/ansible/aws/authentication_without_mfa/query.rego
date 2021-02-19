package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	modules := {"community.aws.sts_assume_role", "sts_assume_role"}

	attributes := {"mfa_serial_number", "mfa_token"}

	object.get(task[modules[index]], attributes[j], "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.%s is set", [modules[index], attributes[j]]),
		"keyActualValue": sprintf("%s.%s is undefined", [modules[index], attributes[j]]),
	}
}