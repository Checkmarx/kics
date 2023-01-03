package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_aks", "azure_rm_aks"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	not common_lib.valid_key(aks, "enable_rbac")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.enable_rbac should be defined",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_rbac", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_aks.enable_rbac should be set to 'yes' or 'true'",
		"keyActualValue": "azure_rm_aks.enable_rbac is not set to 'yes' or 'true'",
	}
}
