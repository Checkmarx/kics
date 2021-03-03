package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_containerregistry", "azure_rm_containerregistry"}
	taskContainerRegistry := task[modules[index]]

	not checkLocks(taskContainerRegistry)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}.resource_group", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.resource_group is referenced by an existing lock", [modules[index]]),
		"keyActualValue": sprintf("%s.resource_group is not referenced by a lock", [modules[index]]),
	}
}

checkLocks(taskContainerRegistry) {
	taskLock := ansLib.tasks[_][_].azure_rm_lock
	contains(taskLock, taskContainerRegistry.resource_group)
}

contains(taskLock, taskContainerRegistry) {
	taskLock.resource_group == taskContainerRegistry
}
