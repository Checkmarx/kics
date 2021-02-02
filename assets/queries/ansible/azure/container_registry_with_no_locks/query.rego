package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

    modules := {"azure.azcollection.azure_rm_containerregistry", "azure_rm_containerregistry"}

	taskContainerRegistry := task[modules[index]]

	not checkLocks(taskContainerRegistry)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{%s}}.resource_group", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.resource_group is referenced by an existing lock", [modules[index]]),
		"keyActualValue": sprintf("%s.resource_group is not referenced by a lock", [modules[index]]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

checkLocks(taskContainerRegistry) {
	document2 := input.document[x]
	taskLock := getTasks(document2)[t2].azure_rm_lock
	contains(taskLock, taskContainerRegistry.resource_group)
}

contains(taskLock, taskContainerRegistry) {
	taskLock.resource_group == taskContainerRegistry
}
