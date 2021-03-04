package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	keyvault := object.get(task.azure_rm_keyvault, "enable_soft_delete", "undefined")
	ansLib.isAnsibleFalse(keyvault)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_keyvault}}.enable_soft_delete", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete is true",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task.azure_rm_keyvault, "enable_soft_delete", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_keyvault}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete is defined",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is undefined",
	}
}
