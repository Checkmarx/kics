package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules = {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}
	storageAccount := task[modules[index]]

	object.get(storageAccount, "https_only", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.https_only is defined", [modules[index]]),
		"keyActualValue": sprintf("%s.https_only is undefined (defaults to false)", [modules[index]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules = {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}
	storageAccount := task[modules[index]]

	not ansLib.isAnsibleTrue(storageAccount.https_only)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.https_only", [task.name, modules[index]]),
		"issueType": "WrongValue",
		"keyExpectedValue": sprintf("%s should have https_only set to true", [modules[index]]),
		"keyActualValue": sprintf("%s has https_only set to false", [modules[index]]),
	}
}
