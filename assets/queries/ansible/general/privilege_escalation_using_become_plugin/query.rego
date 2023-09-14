package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	become_exists := object.get(input.document[i].playbooks[_], "become", false)
	become_exists == false

	task := ansLib.tasks[id][t]
	input.document[i].id == id

	commonLib.valid_key(task, "become_user")

	b_exists := object.get(task, "become", false)
	b_exists == false

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

CxPolicy[result] {
	commonLib.valid_key(input.document[i].playbooks[j], "become_user")

	tasks := ansLib.tasks[id]
	
	count([x | x := check_become(tasks, id); x == true]) == 0
	
    result := {
		"documentId": id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("become_user={{%s}}", [input.document[i].playbooks[j].become_user]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'become' should be defined and set to 'true'",
		"keyActualValue": "'become' is not defined",
	}
}

check_become(tasks, id){
	input.document[i].id == id
	task := tasks[i]
	not commonLib.valid_key(task, "become_user")
	object.get(task, "become", false) == false
}