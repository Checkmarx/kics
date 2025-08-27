package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
    ansLib.checkState(task)

	action := task["ansible.builtin.firewalld"]
	not commonLib.valid_key(action, "rich_rule")

	result := {
		"documentId": id,
		"resourceName": task.name,
		"resourceType": "ansible.builtin.firewalld",
		"searchKey": sprintf("name={{%s}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'no_log' should be defined and set to 'true' in order to not expose sensitive data",
		"keyActualValue": "'no_log' is set to false",
	}
}