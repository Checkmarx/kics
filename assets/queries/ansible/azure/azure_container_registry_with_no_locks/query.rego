package Cx

import data.generic.common as common_lib
import data.generic.ansible as ans_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_containerregistry", "azure_rm_containerregistry"}
	containerRegistry := task[modules[m]]
	ans_lib.checkState(containerRegistry)

	not checkLocks(containerRegistry, task)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be referenced by an existing lock", [modules[m]]),
		"keyActualValue": sprintf("'%s' is not referenced by an existing lock", [modules[m]]),
		"searchLine": common_lib.build_search_line(["playbooks", task, modules[m]], []),
	}
}

matches(containerRegistry, taskContainerRegistry, taskLock) {
	taskLock.resource_group == containerRegistry.resource_group
} else {
	id := sprintf("%s.id", [taskContainerRegistry.register])
	contains(taskLock.managed_resource_id, id)
}

checkLocks(containerRegistry, taskContainerRegistry) {
	modules := {"azure.azcollection.azure_rm_lock", "azure_rm_lock"}
	taskLock := ans_lib.tasks[_][_][modules[_]]
	ans_lib.checkState(taskLock)
	matches(containerRegistry, taskContainerRegistry, taskLock)
}
