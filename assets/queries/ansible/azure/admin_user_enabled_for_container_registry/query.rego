package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_containerregistry", "azure_rm_containerregistry"}
	containerReg := task[modules[m]]
	ansLib.checkState(containerReg)

	ansLib.isAnsibleTrue(containerReg.admin_user_enabled)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.admin_user_enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_containerregistry.admin_user_enabled should be false or undefined (defaults to false)",
		"keyActualValue": "azure_rm_containerregistry.admin_user_enabled is true",
	}
}
