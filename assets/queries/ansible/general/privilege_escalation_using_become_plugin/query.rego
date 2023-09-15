package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	playbook := input.document[i].playbooks[_]
	become_exists := object.get(playbook, "become", false)
	become_exists == false
	commonLib.valid_key(playbook, "become_user")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("name={{%s}}.become_user={{%s}}", [playbook.name, playbook.become_user]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'become' should be defined and set to 'true' in order to perform an action with %s", [playbook.become_user]),
		"keyActualValue": "'become' is not defined or is set to 'false'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	become_exists := object.get(task, "become", false)
	become_exists == false
	
	commonLib.valid_key(task, "become_user")

    result := {
		"documentId": id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("name={{%s}}.become_user={{%s}}", [task.name, task.become_user]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'become' should be defined and set to 'true' in order to perform an action with %s", [task.become_user]),
		"keyActualValue": "'become' is not defined or is set to 'false'",
	}
}