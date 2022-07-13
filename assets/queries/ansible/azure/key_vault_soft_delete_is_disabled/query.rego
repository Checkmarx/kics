package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_keyvault", "azure_rm_keyvault"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	keyvault := task[modules[m]]
	ansLib.checkState(keyvault)

	ansLib.isAnsibleFalse(keyvault.enable_soft_delete)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_soft_delete", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete should be true",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	keyvault := task[modules[m]]
	ansLib.checkState(keyvault)

	not common_lib.valid_key(keyvault, "enable_soft_delete")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete should be defined",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is undefined",
	}
}
