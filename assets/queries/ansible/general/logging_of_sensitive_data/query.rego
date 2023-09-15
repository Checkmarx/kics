package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	not commonLib.valid_key(task, "no_log")

	action := task["ansible.builtin.user"]
	commonLib.valid_key(action, "password")

	result := {
		"documentId": id,
		"resourceName": task.name,
		"resourceType": "ansible.builtin.user",
		"searchKey": sprintf("name={{%s}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'no_log' should be defined and set to 'true' in order to not expose sensitive data",
		"keyActualValue": "'no_log' is not defined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task.no_log == false

	action := task["ansible.builtin.user"]
	commonLib.valid_key(action, "password")

	result := {
		"documentId": id,
		"resourceName": task.name,
		"resourceType": "ansible.builtin.user",
		"searchKey": sprintf("name={{%s}}.no_log", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'no_log' should be set to 'true' in order to not expose sensitive data",
		"keyActualValue": "'no_log' is set to false",
	}
}