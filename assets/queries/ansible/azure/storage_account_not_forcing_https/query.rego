package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task[modules[index]]
	ansLib.checkState(storageAccount)

	not  common_lib.valid_key(storageAccount, "https_only")

	result := {
		"documentId": id,
		"resourceType": modules[index],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_storageaccount.https_only should be defined",
		"keyActualValue": "azure_rm_storageaccount.https_only is undefined (defaults to false)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task[modules[index]]
	ansLib.checkState(storageAccount)

	not ansLib.isAnsibleTrue(storageAccount.https_only)

	result := {
		"documentId": id,
		"resourceType": modules[index],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.https_only", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount should have https_only set to true",
		"keyActualValue": "azure_rm_storageaccount has https_only set to false",
	}
}
