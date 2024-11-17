package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	some playbook in doc.playbooks
	playbook.become == false
	commonLib.valid_key(playbook, "become_user")

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "become",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'become' should be defined and set to 'true' in order to perform an action with %s", [playbook.become_user]),
		"keyActualValue": "'become' is set to 'false'",
	}
}

CxPolicy[result] {
	some doc in input.document
	some playbook in doc.playbooks
	not commonLib.valid_key(playbook, "become")
	commonLib.valid_key(playbook, "become_user")

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("become_user={{%s}}", [playbook.become_user]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'become' should be defined and set to 'true' in order to perform an action with %s", [playbook.become_user]),
		"keyActualValue": "'become' is not defined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	task.become == false
	commonLib.valid_key(task, "become_user")

	result := {
		"documentId": id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("name={{%s}}.become_user={{%s}}.become", [task.name, task.become_user]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'become' should be to 'true' in order to perform an action with %s", [task.become_user]),
		"keyActualValue": "'become' is set to 'false'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	not commonLib.valid_key(task, "become")
	commonLib.valid_key(task, "become_user")

	result := {
		"documentId": id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("name={{%s}}.become_user={{%s}}", [task.name, task.become_user]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'become' should be defined and set to 'true' in order to perform an action with %s", [task.become_user]),
		"keyActualValue": "'become' is not defined",
	}
}
