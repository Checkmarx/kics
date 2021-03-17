package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_aks", "azure_rm_aks"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	object.get(aks, "enable_rbac", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.enable_rbac is defined",
		"keyActualValue": "azure_rm_aks.enable_rbac is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	not ansLib.isAnsibleTrue(aks.enable_rbac)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_rbac", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_aks.enable_rbac is set to 'yes' or 'true'",
		"keyActualValue": "azure_rm_aks.enable_rbac is not set to 'yes' or 'true'",
	}
}
