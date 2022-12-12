package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_storageblob", "azure_rm_storageblob"}
	storageblob := task[modules[m]]
	ansLib.checkState(storageblob)

	hasPublicAccess(lower(storageblob.public_access))

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.public_access", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageblob.public_access should not be set",
		"keyActualValue": "azure_rm_storageblob.public_access is equal to 'blob' or 'container'",
	}
}

hasPublicAccess("blob") = true

hasPublicAccess("container") = true
