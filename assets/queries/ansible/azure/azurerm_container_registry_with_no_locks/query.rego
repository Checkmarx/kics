package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_containerregistry", "azure_rm_containerregistry"}
	containerRegistry := task[modules[m]]
	ansLib.checkState(containerRegistry)

	not checkLocks(containerRegistry)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.resource_group", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_containerregistry.resource_group is referenced by an existing lock",
		"keyActualValue": "azure_rm_containerregistry.resource_group is not referenced by a lock",
	}
}

checkLocks(containerRegistry) {
	modules := {"azure.azcollection.azure_rm_lock", "azure_rm_lock"}
	taskLock := ansLib.tasks[_][_][modules[_]]
	ansLib.checkState(taskLock)
	taskLock.resource_group == containerRegistry.resource_group
}
