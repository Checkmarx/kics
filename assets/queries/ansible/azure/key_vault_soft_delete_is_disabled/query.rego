package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_keyvault", "azure_rm_keyvault"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	keyvault := task[modules[m]]
	ansLib.checkState(keyvault)

	ansLib.isAnsibleFalse(keyvault.enable_soft_delete)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_soft_delete", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete is true",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	keyvault := task[modules[m]]
	ansLib.checkState(keyvault)

	object.get(keyvault, "enable_soft_delete", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete is defined",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is undefined",
	}
}
